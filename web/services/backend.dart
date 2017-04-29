import 'dart:async';
import 'dart:html';
import 'package:angel_client/browser.dart';
import 'package:angel_websocket/browser.dart';
import 'package:angular2/angular2.dart';

@Injectable()
class BackendService implements OnDestroy {
  final StreamController _onConnected = new StreamController.broadcast();
  Map<String, WebSocketsService> _services = {};

  Stream get onConnected => _onConnected.stream;

  final Rest rest = new Rest(window.location.origin);
  final WebSockets ws = new WebSockets('ws://${window.location.host}/ws');

  Future connectWebSocket(String authToken) {
    ws.authToken = authToken;
    return ws.connect().then((_) {
      _onConnected.add(null);
    });
  }

  WebSocketsService service(String path) =>
      _services.putIfAbsent(path, () => ws.service(path));

  @override
  ngOnDestroy() {
    _onConnected.close();
  }
}
