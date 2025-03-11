import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:warp_chats/models/thread.dart';
import 'package:warp_chats/screens/signin_screen.dart';
import 'package:warp_chats/widgets/thread_item.dart';

class ThreadsScreen extends StatefulWidget {
  const ThreadsScreen({super.key});

  @override
  State<ThreadsScreen> createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends State<ThreadsScreen> {
  late Stream<QuerySnapshot> myThreads;

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  Future<void> _setupPushNotifications() async {
    // request permission for push notifications
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
  }

  Future<void> _subscribeToThreads(List<String> topics) async {
    // for each thread that we are part of
    // let's subscribe to that topic
    // so that in backend, we can target topics
    // as recepients of push notifications
    await Future.forEach(topics, (topic) {
      final fcm = FirebaseMessaging.instance;
      fcm.subscribeToTopic(topic);
    });
  }

  @override
  Widget build(BuildContext context) {
    myThreads = fs
        .collection('user_threads')
        .doc(fa.currentUser!.uid)
        .collection('threads')
        .snapshots();

    myThreads.listen((snapshot) async {
      await _subscribeToThreads(
          snapshot.docs.map((thread) => thread.id).toList());
    });

    return StreamBuilder(
        stream: myThreads,
        builder: (ctx, threadsSnapshot) {
          if (threadsSnapshot.connectionState == ConnectionState.waiting) {
            // TODO: Return a Skeletonizer items loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!threadsSnapshot.hasData || threadsSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Hi there! Quite empty no?'),
            );
          }

          final loadedThreads = threadsSnapshot.data!.docs;

          return ListView.builder(
              itemCount: loadedThreads.length,
              itemBuilder: (ctx, index) {
                // create a new Thread item

                Thread thread = Thread(
                    id: loadedThreads[index].id,
                    name: loadedThreads[index].get('name'));

                return ThreadItem(thread);
              });
        });
  }
}
