library chat.models.user;

import 'package:angel_framework/common.dart';
import 'package:owl/annotation/json.dart';
import 'user.json.g.dart';

@JsonClass()
class User extends Model {
  @override
  String id;
  String githubId, name, avatar;

  User({this.id, this.githubId, this.name, this.avatar});
  factory User.fromMap(Map map) => UserMapper.parse(map);
  Map<String, dynamic> toJson() => UserMapper.map(this);
}
