import 'package:angel_client/angel_client.dart';
import 'package:angular2/angular2.dart';
import 'package:chat/src/models/user.dart';
import 'backend.dart';

@Injectable()
class AuthService {
  final BackendService _backendService;
  User _user;

  User get user => _user;

  AuthService(this._backendService) {
    _backendService.rest.authenticate().then(_handleAuth);
  }

  _handleAuth(AngelAuthResult auth) async {
    _user = User.parse(auth.data);
    await _backendService.connectWebSocket(auth.token);
  }

  void showPopup() {
    _backendService.ws
        .authenticateViaPopup('/auth/google')
        .first
        .then((jwt) async {
      var auth = await _backendService.rest
          .authenticate(type: 'token', credentials: {'token': jwt});
      await _handleAuth(auth);
    });
  }
}
