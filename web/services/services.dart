import 'auth.dart';
import 'backend.dart';
import 'message.dart';

const List<Type> CHAT_PROVIDERS = const [
  BackendService,
  AuthService,
  MessageService
];
