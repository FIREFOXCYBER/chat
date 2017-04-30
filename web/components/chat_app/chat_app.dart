import 'package:angular2/angular2.dart';
import 'package:chat/src/models/message.dart';
import '../../pipes/image_url.dart';
import '../../pipes/time_ago.dart';
import '../../services/auth.dart';
import '../../services/message.dart';

@Component(
    selector: 'chat-app',
    templateUrl: 'chat_app.html',
    styleUrls: const ['chat_app.css'],
    pipes: const [ImageUrlPipe, TimeAgoPipe])
class ChatAppComponent {
  final MessageService _messageService;
  final AuthService auth;
  List<Message> get messages => _messageService.messages;
  String messageText = '';

  ChatAppComponent(this._messageService, this.auth);

  login() {
    auth.showPopup();
  }

  submit() {
    if (messageText.isNotEmpty) {
      _messageService.createMessage(new Message(text: messageText));
      messageText = '';
    }
  }
}
