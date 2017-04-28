import 'package:angel_validate/angel_validate.dart';

final Validator MESSAGE = new Validator({
  'text': [isString, isNotEmpty],
  'avatar': [isString, isNotEmpty, isUrl]
});

final Validator CREATE_MESSAGE = MESSAGE.extend({})
  ..requiredFields.addAll(['text', 'avatar', 'userId']);
