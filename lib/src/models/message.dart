import 'package:angel_framework/common.dart';
import 'package:owl/annotation/json.dart';
import 'message.json.g.dart';

@JsonClass()
class Message extends Model {
  @override
  String id;
  String userId, text;

  Message({String id, this.userId, this.text});
  factory Message.fromMap(Map map) => MessageMapper.parse(map);
  Map<String, dynamic> toJson() => MessageMapper.map(this);
}
