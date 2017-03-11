import 'package:angel_common/angel_common.dart';
import 'package:angel_framework/hooks.dart' as hooks;
import 'package:mongo_dart/mongo_dart.dart';
import '../models/user.dart';
import '../validators/user.dart';

configureServer(Db db) {
  return (Angel app) async {
    app.use('/api/users', new MongoService(db.collection('users')));

    HookedService service = app.service('api/users');

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
    service.beforeAll((e) {
      if (e.params == null)
        e.params = {'broadcast': false};
      else
        e.params['broadcast'] = false;
    });

    // Validate new users.
    service.beforeCreated..listen(validateEvent(CREATE_USER));

    // Remove sensitive data from serialized JSON.
    service.afterAll(hooks.remove(['githubId']));

    // Deserialize data as a User without reflection.
    service.afterAll(hooks.transform((map) => new User.fromMap(map)));
  };
}
