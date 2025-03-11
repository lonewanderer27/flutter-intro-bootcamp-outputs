import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/streams.dart';
import 'package:warp_chats/models/avatar.dart';
import 'package:warp_chats/models/chat.dart';
import 'package:warp_chats/widgets/chat_item.dart';
import 'package:warp_chats/widgets/empty_chat.dart';
import 'package:http/http.dart' as http;
import 'signin_screen.dart';

class PublicChatScreen extends StatefulWidget {
  const PublicChatScreen({super.key});

  @override
  State<PublicChatScreen> createState() => _PublicChatScreenState();
}

class _PublicChatScreenState extends State<PublicChatScreen> {
  // TODO: Use bloc for this
  List<QueryDocumentSnapshot> prevChats = [];
  List<QueryDocumentSnapshot> prevUsers = [];

  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _subscribeToChats() async {
    // for each thread that we are part of
    // let's subscribe to that topic
    // so that in backend, we can target topics
    // as recepients of push notifications
    final fcm = FirebaseMessaging.instance;
    fcm.subscribeToTopic('chats');
  }

  Future<void> _submitMessage() async {
    final message = _messageController.text;

    // return if the message is empty
    if (message.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // add the new message
    var chatRef = await fs.collection('chats').add({
      'message': message,
      'createdAt': DateTime.now().toIso8601String().toString(),
      'userId': fa.currentUser!.uid
    });

    // reset our text input
    _messageController.clear();

    setState(() {
      _isLoading = false;
    });

    try {
      // get the default local url
      String backendUrl = dotenv.env['BACKEND_URL']!;

      // otherwise if we're in release mode, replace it with the prod url
      if (kReleaseMode) {
        backendUrl = dotenv.env['PROD_BACKEND_URL']!;
      }

      // send request to backend for notification
      final res = await http
          .post(Uri.parse('$backendUrl/notifications/chats/${chatRef.id}'));

      debugPrint('Notification: ${res.body}');
    } catch (error) {
      debugPrint('Notification Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetch all the chats
    Stream<QuerySnapshot> chats = fs
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots();

    _subscribeToChats();

    // fetch all the users in this thread
    Stream<QuerySnapshot> users = fs.collection('users').snapshots();

    var streams = CombineLatestStream.combine2(chats, users,
        (QuerySnapshot? chatSnapshot, QuerySnapshot? userSnapshot) {
      return {
        'chats': chatSnapshot?.docs ?? prevChats,
        'users': userSnapshot?.docs ?? prevUsers
      };
    });

    return Column(
      children: [
        Expanded(
            child: StreamBuilder(
                stream: streams,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final chatDocs = snapshot.data!['chats'];
                  final userDocs = snapshot.data!['users'];

                  if (chatDocs!.isEmpty || userDocs!.isEmpty) {
                    return const EmptyChat();
                  }

                  prevChats = chatDocs;
                  prevUsers = userDocs;

                  final lastChat = chatDocs.first;

                  return ListView.builder(
                      reverse: true,
                      itemCount: chatDocs.length,
                      itemBuilder: (ctx, index) {
                        var prevChat = index == 0 ? null : chatDocs[index - 1];
                        var chat = chatDocs[index];
                        var user = userDocs.firstWhere(
                            (user) => user.id == chat.get('userId'));
                        var prevUser = index == 0
                            ? null
                            : userDocs.firstWhere(
                                (user) => user.id == prevChat?.get('userId'));

                        // if the previous chat user is different from the current one
                        // and it is not the last item
                        // display the avatar
                        final displayAvatar = prevUser == null ||
                            prevUser.id != user.id ||
                            index == 0;

                        Chat chatItem = Chat(
                            id: chat.id,
                            createdAt: DateTime.parse(chat.get('createdAt')),
                            message: chat.get('message'),
                            userId: user.id,
                            username: user.get('username'),
                            avatar: Avatar(base64: user.get('avatarBase64')));

                        return ChatItem(
                          chatItem,
                          showDateTime: lastChat.id == chat.id,
                          showAvatar: displayAvatar,
                        );
                      });
                })),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Expanded(
              child: Row(
            children: [
              Expanded(
                  child: TextField(
                readOnly: _isLoading,
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(label: Text('Send a message...')),
              )),
              IconButton.filled(
                  onPressed: _isLoading ? null : _submitMessage,
                  icon: Icon(Icons.send))
            ],
          )),
        )
      ],
    );
  }
}
