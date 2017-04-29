import 'package:angular_components/angular_components.dart';
import 'package:angular2/angular2.dart';
import 'package:chat/src/models/message.dart';
import 'package:material_menu/material_menu.dart';
import 'package:material_toolbar/material_toolbar.dart';
import '../../services/auth.dart';
import '../../services/message.dart';

@Component(selector: 'chat-app', templateUrl: 'chat_app.html', styles: const [
  '''
      material-fab {
        position: fixed;
        background-color: rgb(66, 133, 244) !important;
        color: white !important;
        bottom: 1em;
        right: 1em;
        z-index: 999;
      }

      material-toolbar {
        position: fixed;
        width: 100%;
        z-index: 999;
        top: 0;
      }

      #composer {
        background-color: #fff;
        position: fixed;
        bottom: 0;
        width: 100%;
        left: 0;
        padding: 1em;
        box-shadow: rgba(0, 0, 0, 0.156863) 0px 1px 10px, rgba(0, 0, 0, 0.227451) 0px 1px 10px;
        z-index: 998;
      }
      '''
], directives: const [
  materialDirectives,
  menuDirectives,
  MaterialMenuComponent,
  MaterialToolbarComponent
])
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
