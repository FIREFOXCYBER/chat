import 'package:angular_components/angular_components.dart';
import 'package:angular2/platform/browser.dart';
import 'package:material_menu/material_menu.dart';
import 'package:material_toolbar/material_toolbar.dart';
import 'components/chat_app/chat_app.dart';
import 'services/services.dart';

main() => bootstrap(ChatAppComponent, [
      CHAT_PROVIDERS,
      materialProviders
    ]);
