library chat.config;

import 'dart:convert';
import 'dart:io';
import 'package:angel_common/angel_common.dart';
import 'package:angel_websocket/server.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'plugins/plugins.dart' as plugins;

/// This is a perfect place to include configuration and load plug-ins.
configureServer(Angel app) async {
  await app.configure(loadConfigurationFile());
  var db = new Db(app.mongo_db);
  await db.open();
  app.container.singleton(db);

  // Use `JSON.decode` instead of reflection for serialization - improves performance
  app.injectSerializer(JSON.encode);

  await app.configure(mustache(new Directory('views')));
  await plugins.configureServer(app);
  app.justBeforeStart.add(new AngelWebSocket());
}
