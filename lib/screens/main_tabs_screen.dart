import 'package:flutter/material.dart';

import '../widgets/video_search.dart';
import '../widgets/sort_order_dialog.dart';
import '../widgets/app_drawer.dart';

import '../screens/movies_list_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/authors_screen.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<MainTabsScreen> createState() => MainTabsScreenState();
}

class MainTabsScreenState extends State<MainTabsScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Center(
            child: Image.asset(
              "assets/images/logo.png",
              //fit: BoxFit.cover,
              scale: 1,
            ),
          ),
          actions: [
            IconButton(
              onPressed: (() {
                showSearch(context: context, delegate: VideoSearch());
              }),
              icon: const Icon(Icons.search),
              iconSize: 28,
            ),
            IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return SortOrderDialog();
                    });
                  }),
              icon: const Icon(Icons.sort_by_alpha_rounded),
              iconSize: 28,
              //color: const Color.fromARGB(255, 255, 186, 8),
            )
          ],
        ),
        drawer: const AppDrawer(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(5),
          child: TabBar(controller: tabController, tabs: [
            Tab(
              text: 'Movies',
              icon: Icon(Icons.video_collection),
            ),
            Tab(
              text: 'Channels',
              icon: Icon(Icons.tv),
            ),
            Tab(
              text: 'Authors',
              icon: Icon(Icons.person_search),
            )
          ]),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            MovieListScreen(),
            ChannelsScreen(),
            AuthorsScreen(),
          ],
        ),
      ),
    );
  }
}
