import 'package:angular2/platform/browser.dart';
import 'components/chat_app/chat_app.dart';
import 'services/services.dart';

main() => bootstrap(ChatAppComponent, [CHAT_PROVIDERS]);
