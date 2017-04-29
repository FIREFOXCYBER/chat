import 'package:angel_common/angel_common.dart';
import 'package:angel_framework/hooks.dart' as hooks;
import 'package:angel_rethink/angel_rethink.dart';
import 'package:angel_websocket/hooks.dart' as ws;
import 'package:rethinkdb_driver2/rethinkdb_driver2.dart';
import '../models/user.dart';
import '../validators/user.dart';
import 'websocket.dart';

configureServer(Connection connection, Rethinkdb r) {
  return (Angel app) async {
    app.use(
        '/api/users',
        new RethinkService(connection, r.table('users'))
          ..properties['ws:filter'] = onlyBroadcastToAuthenticatedUsers);

    var service = app.service('api/users') as HookedService;

    // Prevent clients from doing anything to the `users` service,
    // apart from reading a single user's data.
    service.before([
      HookedServiceEvent.INDEXED,
      HookedServiceEvent.CREATED,
      HookedServiceEvent.MODIFIED,
      HookedServiceEvent.UPDATED,
      HookedServiceEvent.REMOVED
    ], hooks.disable());

    // Don't broadcast user events over WebSockets - they're sensitive data!
    service.before([HookedServiceEvent.MODIFIED, HookedServiceEvent.UPDATED],
        ws.doNotBroadcast());

    // Validate new users.
    service.beforeCreated..listen(validateEvent(CREATE_USER));

    service
      ..beforeCreated.listen(hooks.addCreatedAt())
      ..beforeModify(hooks.addUpdatedAt());

    // Remove sensitive data from serialized JSON.
    service.afterAll(hooks.remove(['googleId']));

    // Deserialize data as a User without reflection.
    service.afterAll(hooks.transform(User.parse));
  };
}
