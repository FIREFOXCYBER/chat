import 'package:angel_validate/angel_validate.dart';

final RegExp _URL = new RegExp(
    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');
final Matcher isUrl =
    predicate((x) => _URL.hasMatch(x?.toString()), 'is a URL');

final Validator USER = new Validator({
  'githubId': [isString, isNotEmpty],
  'name': [isString, isNotEmpty],
  'password': [isString, isNotEmpty, isUrl]
});

final Validator CREATE_USER = USER.extend({})
  ..requiredFields.addAll(['githubId', 'name', 'avatar']);
