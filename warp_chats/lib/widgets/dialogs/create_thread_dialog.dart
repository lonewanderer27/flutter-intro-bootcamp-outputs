import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:warp_chats/screens/signin_screen.dart';

class CreateThreadDialog extends StatefulWidget {
  const CreateThreadDialog({super.key});

  @override
  State<CreateThreadDialog> createState() => _CreateThreadDialogState();
}

class _CreateThreadDialogState extends State<CreateThreadDialog> {
  final _textController = TextEditingController();
  bool isLoading = false;
  String? errorText;

  Future<void> handleCreateThread() async {
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

    try {
      // connect to backend to create thread
      final res = await http.post(Uri.parse('$backendUrl/threads/new'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'userId': fa.currentUser!.uid, 'name': _textController.text}));

      inspect(res);

      setState(() {
        if (res.statusCode != 200) {
          switch (res.statusCode) {
            default:
              {
                errorText = 'There has been an error, please try again later.';
              }
          }
        }
        isLoading = false;
      });

      if (mounted) Navigator.pop(context);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chat Name'),
      content: TextField(
        controller: _textController,
        readOnly: isLoading,
        decoration: InputDecoration(hintText: "Enter the name of the chat", errorText: errorText),
      ),
      actions: [TextButton(onPressed: handleCreateThread, child: isLoading ? CircularProgressIndicator() : Text('Create'))],
    );
  }
}
