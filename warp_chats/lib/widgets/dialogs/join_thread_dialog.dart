import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:warp_chats/screens/signin_screen.dart';

class JoinThreadDialog extends StatefulWidget {
  const JoinThreadDialog({super.key});

  @override
  State<JoinThreadDialog> createState() => _JoinThreadDialogState();
}

class _JoinThreadDialogState extends State<JoinThreadDialog> {
  final _textController = TextEditingController();
  bool isLoading = false;
  String? errorText;

  Future<void> handleJoinThread() async {
    // connect to backend to join thread
    // checks:
    // - warp invite code must exist
    // - the referenced thread must exist
    // - the user has to be a non-member yet

    // clear error and set loading to true
    setState(() {
      errorText = null;
      isLoading = true;
    });

    // get the default local url
    String backendUrl = dotenv.env['BACKEND_URL']!;

    // otherwise if we're in release mode, replace it with the prod url
    if (kReleaseMode) {
      backendUrl = dotenv.env['PROD_BACKEND_URL']!;
    }

    final res = await http.post(Uri.parse('$backendUrl/threads/join'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            {'userId': fa.currentUser!.uid, 'warpId': _textController.text}));

    setState(() {
      switch (res.statusCode) {
        case 404:
          {
            errorText = 'Code is invalid.';
          }
        case 409:
          {
            errorText = 'You are already a part of this thread.';
          }
        default:
          {
            errorText = 'There has been an error, please try again later.';
          }
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Invite Code'),
      content: TextField(
        controller: _textController,
        readOnly: isLoading,
        decoration: InputDecoration(
            hintText: "Enter the invite code you received",
            errorText: errorText),
      ),
      actions: [
        TextButton(
            onPressed: handleJoinThread,
            child: isLoading ? CircularProgressIndicator() : Text('Join'))
      ],
    );
  }
}
