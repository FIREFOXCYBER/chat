import 'package:angel_common/angel_common.dart';
import 'package:angel_framework/hooks.dart' as hooks;
import 'package:angel_rethink/angel_rethink.dart';
import 'package:angel_security/hooks.dart' as auth;
import 'package:rethinkdb_driver2/rethinkdb_driver2.dart';
import 'websocket.dart';

AngelConfigurer configureServer(Connection connection, Rethinkdb r) {
  return (Angel app) async {
    app.use(
        '/api/messages',
        new RethinkService(connection, r.table('messages'))
          ..properties['ws:filter'] = onlyBroadcastToAuthenticatedUsers);

    var service = app.service('api/messages') as HookedService;

    // Apply security rules:
    //
    // 1. You must be logged in to interact with this service.
    // 2. Messages may not be edited or deleted.
    // 3. The current user's ID is attached to each created message as `userId`.
    service
      ..beforeAll(auth.restrictToAuthenticated())
      ..before([
        HookedServiceEvent.MODIFIED,
        HookedServiceEvent.UPDATED,
        HookedServiceEvent.REMOVED
      ], hooks.disable())
      ..beforeCreated.listen(auth.associateCurrentUser());
  };
}
