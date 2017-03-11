library chat.routes.controllers.auth;

import 'dart:convert';
import 'package:angel_auth_oauth2/angel_auth_oauth2.dart';
import 'package:angel_common/angel_common.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import '../../models/user.dart';

@Expose('/auth')
class AuthController extends Controller {
  AngelAuth auth;

  /// Clients will see the result of `deserializer`, so let's pretend to be a client.
  ///
  /// Our User service is already wired to remove sensitive data from serialized JSON.
  deserializer(String id) async =>
      app.service('api/users').read(id, {'provider': Providers.REST});

  serializer(User user) async => user.id;

  /// Attempt to log a user in
  OAuth2Verifier oauth2Verifier(Service userService) {
    return (oauth2.Client client) async {
      var response = await client.get('https://api.github.com/user');

      if (response.statusCode != 200) return null;

      var ghUser = JSON.decode(response.body) as Map;
      var ghId = ghUser['id'].toString();
      String name = ghUser['name'], avatar = ghUser['avatar_url'];

      List<User> users = await userService.index({
        'query': {'githubId': ghId}
      });

      if (users.isNotEmpty) {
        // User exists, update profile and log in
        var u = users.firstWhere((user) => user.githubId == ghId,
            orElse: () => null);

        if (u == null || u.id == null)
          return null;
        else {
          // Will be auto-deserialized into a User, thanks to our hooks
          return await userService
              .modify(u.id, {'name': name, 'avatar': avatar});
        }
      } else {
        var u = new User(githubId: ghId, name: name, avatar: avatar);
        return await userService.create(u.toJson());
      }
    };
  }

  @override
  call(Angel app) async {
    // Wire up local authentication, connected to our User service
    auth = new AngelAuth(jwtKey: app.jwt_secret, allowCookie: false)
      ..serializer = serializer
      ..deserializer = deserializer
      ..strategies.add(new OAuth2Strategy(
          'github', app.github, oauth2Verifier(app.service('api/users'))));

    await super.call(app);
    await app.configure(auth);
  }

  @Expose('/github')
  authRedirect() => auth.authenticate('github');

  @Expose('/github/callback')
  authCallback() =>
      auth.authenticate('github', new AngelAuthOptions(successRedirect: '/'));
}
