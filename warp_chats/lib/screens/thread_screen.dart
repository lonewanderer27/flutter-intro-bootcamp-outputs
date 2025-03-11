import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:warp_chats/models/chat.dart';
import 'package:warp_chats/models/thread.dart';
import 'package:warp_chats/screens/signin_screen.dart';
import 'package:warp_chats/widgets/chat_item.dart';
import 'package:warp_chats/widgets/dialogs/warp_thread_dialog.dart';
import 'package:warp_chats/widgets/empty_chat.dart';
import 'package:http/http.dart' as http;

class ThreadScreen extends StatefulWidget {
  const ThreadScreen(this.thread, {super.key});
  final Thread thread;

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    final message = _messageController.text;

    // return if the message is empty
    if (message.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // add the new message
    var chatRef = await fs
        .collection('threads')
        .doc(widget.thread.id)
        .collection('chats')
        .add({
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
      final res = await http.post(Uri.parse(
          '$backendUrl/notifications/threads/${widget.thread.id}/chats/${chatRef.id}'));

      debugPrint('Notification: ${res.body}');
    } catch (error) {
      debugPrint('Notification Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetch all the chats
    Stream<QuerySnapshot> chats = fs
        .collection('threads')
        .doc(widget.thread.id)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots();

    // fetch all the users in this thread
    Stream<QuerySnapshot> users = fs
        .collection('threads')
        .doc(widget.thread.id)
        .collection('users')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => WarpThreadDialog(widget.thread.id));
              },
              icon: Icon(Icons.share))
        ],
        title: Row(
          children: [
            StreamBuilder(
                stream: users,
                builder: (ctx, usersSnapshot) {
                  Widget icon = CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 25),
                  );

                  if (usersSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return icon;
                  }

                  // display our own profile picture if we're on our own chat
                  if (usersSnapshot.hasData &&
                      usersSnapshot.data!.docs.length == 1 &&
                      usersSnapshot.data!.docs.first.get('avatarBase64') !=
                          null) {
                    icon = ClipOval(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Image.memory(
                          base64Decode(usersSnapshot.data!.docs.first
                              .get('avatarBase64')),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }

                  // display the other user's profile picture if users are more than 1
                  if (usersSnapshot.hasData &&
                      usersSnapshot.data!.docs.length > 1) {
                    // lets check first where is the object of the second user
                    // by filtering the ID of the object, we can check
                    // if the ID is not equal to us, then that's the other user
                    // that we need to get the avatarBase64 from
                    var otherUser = usersSnapshot.data!.docs
                        .firstWhere((user) => user.id != fa.currentUser!.uid);

                    icon = ClipOval(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Image.memory(
                          otherUser.get('avatarBase64'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }

                  return icon;

                  // if the amount of users is only 1, then we are in our own chat
                  // therefore we display our profile
                }),
            SizedBox(
              width: 10,
            ),
            Text(widget.thread.name)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: chats,
                builder: (ctx, chatsSnapshot) {
                  if (chatsSnapshot.connectionState ==
                          ConnectionState.waiting &&
                      chatsSnapshot.data == null) {
                    // TODO: Return a Skeletonizer items loading
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!chatsSnapshot.hasData ||
                      chatsSnapshot.data!.docs.isEmpty) {
                    return EmptyChat();
                  }

                  final loadedChats = chatsSnapshot.data!.docs;
                  // the last chat from firebase
                  // becomes the first chat in our list
                  // which is showed at the bottom
                  // therefore that is what we need to show the dateTime for
                  final lastChat = loadedChats.first;

                  return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      reverse: true,
                      itemCount: loadedChats.length,
                      itemBuilder: (ctx, index) {
                        // create a new chat item
                        Chat chat = Chat(
                            id: loadedChats[index].id,
                            createdAt: DateTime.parse(
                                loadedChats[index].get('createdAt')),
                            message: loadedChats[index].get('message'),
                            userId: loadedChats[index].get('userId'),
                            username: 'user 🤩');

                        return ChatItem(
                          chat,
                          showDateTime: lastChat.id == chat.id,
                        );
                      });
                }),
          ),
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
      ),
    );
  }
}
