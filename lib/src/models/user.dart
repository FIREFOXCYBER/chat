library chat.models.user;

import 'package:angel_framework/common.dart';

class User extends Model {
  @override
  String id;
  String googleId, name, avatar;
  @override
  DateTime createdAt, updatedAt;

  User(
      {this.id,
      this.googleId,
      this.name,
      this.avatar,
      this.createdAt,
      this.updatedAt});

  static User parse(Map map) => new User(
      id: map['id'],
      googleId: map['googleId'],
      avatar: map['avatar'],
      name: map['name'],
      createdAt: map.containsKey('createdAt')
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map.containsKey('updatedAt')
          ? DateTime.parse(map['updatedAt'])
          : null);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'googleId': googleId,
      'name': name,
      'avatar': avatar,
      'createdAt': createdAt?.toUtc()?.toIso8601String(),
      'updatedAt': updatedAt?.toUtc()?.toIso8601String(),
    };
  }
}
