import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WarpThreadDialog extends StatefulWidget {
  const WarpThreadDialog(this.threadId, {super.key});
  final String threadId;

  @override
  State<WarpThreadDialog> createState() => _WarpThreadDialogState();
}

class _WarpThreadDialogState extends State<WarpThreadDialog> {
  bool isLoading = false;
  String? errorText;
  QueryDocumentSnapshot? warp;

  void handleCopy() {
    if (warp != null) {
      Clipboard.setData(ClipboardData(text: warp!.id));
    }
  }

  Future<void> generateWarpCode() async {
    // connect to backend to generate warp code for this thread
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
      final res = await http.post(Uri.parse('$backendUrl/warp/new'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({'threadId': widget.threadId}));

      if (res.statusCode != 201) {
        setState(() {
          errorText = 'There has been an error, please try again later.';
        });
      }
    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        errorText = 'There has been an error, please try again later.';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> warps = FirebaseFirestore.instance
        .collection('warp')
        .where('threadId', isEqualTo: widget.threadId)
        .snapshots();

    return AlertDialog(
      title: Text('Warp Code'),
      content: StreamBuilder(
          stream: warps,
          builder: (ctx, warpsSnapshot) {
            Widget content = Column(
              children: [CircularProgressIndicator()],
            );

            if (warpsSnapshot.hasData && warpsSnapshot.data!.docs.isNotEmpty) {
              // only display the first warp code
              warp = warpsSnapshot.data!.docs.first;
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    warp!.id,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: handleCopy,
                    child: Text('Copy'),
                  ),
                ],
              );
            } else {
              content = isLoading
                  ? Column(
                      children: [
                        Text(
                          'Generating invite code..',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        CircularProgressIndicator()
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No invite code found for this thread.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: generateWarpCode,
                          child: Text('Generate Warp Code'),
                        ),
                      ],
                    );
            }

            return content;
          }),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }
}
