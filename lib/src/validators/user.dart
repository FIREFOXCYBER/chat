import 'package:angel_validate/angel_validate.dart';

final Validator USER = new Validator({
  'githubId': [isString, isNotEmpty],
  'name': [isString, isNotEmpty],
  'avatar': [isString, isNotEmpty, isUrl]
});

final Validator CREATE_USER = USER.extend({})
  ..requiredFields.addAll(['githubId', 'name', 'avatar']);
