library chat.config;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:angel_common/angel_common.dart';
import 'package:angel_websocket/server.dart';
import 'package:rethinkdb_driver2/rethinkdb_driver2.dart';
import 'plugins/plugins.dart' as plugins;

/// This is a perfect place to include configuration and load plug-ins.
configureServer(Angel app) async {
  await app.configure(loadConfigurationFile());
  var r = new Rethinkdb();
  var connection = await r.connect(
      host: app.rethinkdb['host'],
      db: app.rethinkdb['db'],
      user: app.rethinkdb['user'],
      password: app.rethinkdb['password'],
      port: app.rethinkdb['port']);
  app.container..singleton(r)..singleton(connection);
  await bootstrapDatabase(r, app.rethinkdb['db'], connection);

  // Use `JSON.encode` instead of reflection for serialization - improves performance
  app
    ..lazyParseBodies = true
    ..injectSerializer(JSON.encode);

  await app.configure(mustache(new Directory('views')));
  await plugins.configureServer(app);
  app.justBeforeStart.add(new AngelWebSocket());
}

bootstrapDatabase(Rethinkdb r, String dbName, Connection connection) async {
  List<String> dbList = await r.dbList().run(connection);

  if (!dbList.contains(dbName)) {
    var result = await r.dbCreate(dbName).run(connection);
    print('Created DB "$dbName": $result');
  }

  var db = r.db(dbName);
  await Future.wait(['messages', 'users']
      .map((name) => assureTable(name, r, db, connection)));
}

assureTable(String name, Rethinkdb r, DB db, Connection connection) async {
  bool exists = await db.tableList().contains(name).run(connection);

  if (!exists) {
    var result = await db.tableCreate(name).run(connection);
    print('Created table "$name": $result');
  }
}
