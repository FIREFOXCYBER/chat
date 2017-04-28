library chat.services;

import 'package:angel_common/angel_common.dart';
import 'package:rethinkdb_driver2/rethinkdb_driver2.dart';
import 'message.dart' as message;
import 'user.dart' as user;

configureServer(Angel app) async {
  var r = app.container.make(Rethinkdb), conn = app.container.make(Connection);
  await app.configure(message.configureServer(conn, r));
  await app.configure(user.configureServer(conn, r));
}
