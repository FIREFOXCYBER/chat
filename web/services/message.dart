import 'package:angel_websocket/browser.dart';
import 'package:angular2/angular2.dart';
import 'package:chat/src/models/message.dart';
import 'backend.dart';

@Injectable()
class MessageService {
  final BackendService _backendService;
  WebSocketsService _service;
  final List<Message> messages = [];

  MessageService(this._backendService) {
    _backendService.onConnected.listen((_) {
      _service = _backendService.service('api/messages');
      _service
        ..onIndexed.listen((e) {
          try {
            messages
              ..clear()
              ..addAll(e.data.map(Message.parse))
              ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
          } catch (e) {
            // Fail silently... ;)
          }
        })
        ..onCreated.listen((e) {
          try {
            messages
              ..add(Message.parse(e.data))
              ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
          } catch (e) {
            // Fail silently... ;)
          }
        })
        ..index();
    });
  }

  void fetchMessages() {
    _service.index();
  }

  void createMessage(Message message) {
    _service.create(message.toJson());
  }
}
