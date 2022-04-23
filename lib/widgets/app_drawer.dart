import 'package:flutter/material.dart';
import '../screens/channels_screen.dart';
import '../screens/tags_screen.dart';

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
              onTap: () {
                Navigator.of(context).pushNamed(ChannelsScreen.routeName);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.tag_sharp),
              title: const Text('Tags'),
              onTap: () {
                Navigator.of(context).pushNamed(TagsScreen.routeName);
              }),
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
