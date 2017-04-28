library chat.models.message;

import 'package:angel_framework/common.dart';
import 'user.dart';

class Message extends Model {
  @override
  String id;
  String userId, text;
  User user;
  @override
  DateTime createdAt, updatedAt;

  Message(
      {String id,
      this.userId,
      this.text,
      this.user,
      this.createdAt,
      this.updatedAt});

  static Message parse(Map map) => new Message(
      id: map['id'],
      userId: map['user'],
      text: map['text'],
      user: map.containsKey('user') ? User.parse(map['user']) : null,
      createdAt: map.containsKey('createdAt')
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map.containsKey('updatedAt')
          ? DateTime.parse(map['updatedAt'])
          : null);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'user': user?.toJson(),
      'createdAt': createdAt?.toUtc()?.toIso8601String(),
      'updatedAt': updatedAt?.toUtc()?.toIso8601String(),
    };
  }
}
