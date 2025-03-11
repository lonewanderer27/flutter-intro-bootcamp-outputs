import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:warp_chats/enums/pages.dart';
import 'package:warp_chats/screens/public_chat_screen.dart';
import 'package:warp_chats/screens/threads_screen.dart';
import 'package:warp_chats/widgets/dialogs/create_thread_dialog.dart';
import 'package:warp_chats/widgets/dialogs/join_thread_dialog.dart';
import 'package:warp_chats/widgets/main_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Pages _selectedPage = Pages.conversations;

  void _selectPage(Pages page) {
    setState(() {
      _selectedPage = page;
    });
  }

  void _handleLogout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage;
    String activePageTitle;
    Widget? fab;

    switch (_selectedPage) {
      case Pages.conversations:
        {
          activePage = const ThreadsScreen();
          activePageTitle = 'Conversations';
          fab = SpeedDial(
            visible: true,
            curve: Curves.bounceInOut,
            spacing: 10,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.person_add_alt_1_outlined),
                  label: 'Join Thread',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => JoinThreadDialog());
                  }),
              SpeedDialChild(
                  child: Icon(Icons.add_comment_outlined),
                  label: 'Create Thread',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => CreateThreadDialog());
                  })
            ],
            child: Icon(Icons.add_outlined),
          );
        }
      case Pages.publicChat:
        {
          activePage = const PublicChatScreen();
          activePageTitle = 'Public Chat';
          // hide FAB on screens that is not conversations page
          fab = null;
        }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(activePageTitle),
          actions: [
            IconButton(onPressed: _handleLogout, icon: Icon(Icons.logout))
          ],
        ),
        drawer: MainDrawer(onSelectScreen: _selectPage),
        body: activePage,
        floatingActionButton: fab);
  }
}
