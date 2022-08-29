import 'package:flutter/material.dart';
import 'package:jugglingtv/models/db_query_helper.dart';
import 'package:jugglingtv/models/main_screen_arguments.dart';
import 'package:jugglingtv/screens/movies_list_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/authors_screen.dart';
import '../main.dart';
import '../providers/videos.dart';
import 'package:provider/provider.dart';

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
              leading: const Icon(Icons.list_alt_outlined),
              title: const Text('All videos'),
              onTap: () {
                // Navigator.of(context).popAndPushNamed(MovieListScreen.routeName,
                //     arguments: MainScreenArguments(
                //       mainScreenMode: MainScreenMode.allVideos,
                //       orderBy: OrderBy.title,
                //       sort: Sort.asc,
                //     ));
                Provider.of<Videos>(context, listen: false).fetchAndSetVideos(
                  OrderBy.title,
                  Sort.asc,
                );
                Navigator.of(context).pop();
                MyApp.mainTabsScreenKey.currentState?.tabController
                    ?.animateTo(0);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Channels'),
              onTap: () {
                Navigator.of(context).popAndPushNamed(ChannelsScreen.routeName);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Authors'),
              onTap: () {
                Navigator.of(context).popAndPushNamed(AuthorsScreen.routeName);
              }),
          // const Divider(),
          // ListTile(
          //     leading: const Icon(Icons.settings),
          //     title: const Text('Settings'),
          //     onTap: () {}),
        ],
      ),
    );
  }
}
