import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Choose your prop!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Channels'),
              onTap: () {}),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.tag_sharp),
              title: const Text('Tags'),
              onTap: () {}),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Authors'),
              onTap: () {}),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {}),
        ],
      ),
    );
  }
}
