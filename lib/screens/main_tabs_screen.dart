import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/video_search.dart';
import '../widgets/sort_order_dialog.dart';
import '../widgets/app_drawer.dart';

import '../screens/movies_list_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/authors_screen.dart';
import '../providers/videos.dart';
import '../main.dart';

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
                  }).then(((value) {
                print(value);
                Provider.of<Videos>(context, listen: false).fetchAndSetVideos(
                  (value as Map)['sortValue'],
                  (value as Map)['orderValue'],
                );
              })),
              icon: const Icon(Icons.sort_by_alpha_rounded),
              iconSize: 28,
              //color: const Color.fromARGB(255, 255, 186, 8),
            )
          ],
        ),
        drawer: const AppDrawer(),
        // floatingActionButton: (showChannel && (tabIndexValue() == 0))
        //     ? FloatingActionButton.extended(
        //         label: Text('Close Channel'),
        //         icon: Icon(Icons.close),
        //         onPressed: () {
        //           print(tabIndex);
        //         },
        //       )
        //     : Container(),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterFloat,
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
