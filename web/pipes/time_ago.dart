import 'package:angular2/angular2.dart';

@Pipe('time_ago')
class TimeAgoPipe implements PipeTransform {
  String transform(DateTime val, [args]) {
    var diff = new DateTime.now().difference(val);

    if (diff.inSeconds < 60)
      return '${diff.inSeconds}s';
    else if (diff.inMinutes < 60)
      return '${diff.inMinutes}m';
    else if (diff.inHours < 24)
      return '${diff.inHours}h';
    else
      return '${diff.inDays}d';
  }
}
