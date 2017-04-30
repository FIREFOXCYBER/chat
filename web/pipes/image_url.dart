import 'package:angular2/angular2.dart';

@Pipe('image_url', pure: true)
class ImageUrlPipe implements PipeTransform {
  String transform(String imageId, [args]) => '/uploads/$imageId.jpg';
}
