import 'package:flutter/material.dart';
import 'package:warp_chats/enums/pages.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(Pages identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    void dismiss() {
      Navigator.pop(context);
    }

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primaryContainer,
              // ignore: deprecated_member_use
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.forum, size: 48, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 18),
                Text('Warp Chats', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary))
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.public, size: 26, color: Theme.of(context).colorScheme.onSurface),
            title: Text('Public Chat',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface, fontSize: 24)),
            onTap: () {
              onSelectScreen(Pages.publicChat);
              dismiss();
            },
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline, size: 26, color: Theme.of(context).colorScheme.onSurface),
            title: Text('Conversations',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface, fontSize: 24)),
            onTap: () {
              onSelectScreen(Pages.conversations);
              dismiss();
            },
          )
        ],
      ),
    );
  }
}
