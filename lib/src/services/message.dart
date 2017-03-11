import 'package:angel_common/angel_common.dart';
import 'package:angel_framework/hooks.dart' as hooks;
import 'package:angel_security/hooks.dart' as auth;
import 'package:mongo_dart/mongo_dart.dart';
import 'websocket.dart';

AngelConfigurer configureServer(Db db) {
  return (Angel app) async {
    app.use(
        '/api/messages',
        new MongoService(db.collection('messages'))
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
