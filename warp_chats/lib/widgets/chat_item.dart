import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warp_chats/models/chat.dart';
import 'package:warp_chats/screens/signin_screen.dart';

class ChatItem extends StatefulWidget {
  const ChatItem(this.chat,
      {super.key, this.showDateTime = false, this.showAvatar = false});
  final Chat chat;
  final bool showDateTime;
  final bool showAvatar;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  late bool _showDateTime;

  @override
  void initState() {
    _showDateTime = widget.showDateTime;
    super.initState();
  }

  void _toggleDateTime() {
    setState(() {
      _showDateTime = !_showDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool me = widget.chat.userId == fa.currentUser!.uid ? true : false;

    DateTime dateTimeToday = DateTime.now();
    String formattedDate = '';
    // if the date is still today, only output the time
    formattedDate = DateFormat('jm').format(widget.chat.createdAt);

    if (dateTimeToday.day != widget.chat.createdAt.day) {
      // otherwise, include a "Yesterday" at the start
      formattedDate = 'Yesterday at $formattedDate';
    } else {
      formattedDate = 'Today at $formattedDate';
    }

    var avatarWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipOval(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: (widget.showAvatar && widget.chat.avatar?.base64 != null)
              ? Image.memory(
                  base64Decode(widget.chat.avatar!.base64),
                  fit: BoxFit.cover,
                )
              : SizedBox(
                  width: 40,
                ),
        ),
      ),
    );

    return Expanded(
        child: InkWell(
      onTap: _toggleDateTime,
      child: Row(
        // if it's our chat, we display it to the right
        // if it's others, we display it to the left
        mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!me) avatarWidget,
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                crossAxisAlignment:
                    me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.message,
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize),
                  ),
                  if (_showDateTime)
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.grey),
                    )
                ],
              ),
            ),
          ),
          if (me) avatarWidget
        ],
      ),
    ));
  }
}
