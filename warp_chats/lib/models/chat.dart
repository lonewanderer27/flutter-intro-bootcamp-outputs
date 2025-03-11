import 'package:warp_chats/models/avatar.dart';

class Chat {
  final String message;
  final String id;
  final DateTime createdAt;
  final String userId;
  final String? username;
  final Avatar? avatar;

  const Chat(
      {required this.id,
      required this.message,
      required this.createdAt,
      required this.username,
      required this.userId,
      this.avatar});
}
