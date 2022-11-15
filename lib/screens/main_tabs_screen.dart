import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io' show Platform;

import '../widgets/video_search.dart';
import '../widgets/sort_order_dialog.dart';
import '../widgets/app_drawer.dart';

import '../screens/movies_list_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/authors_screen.dart';
import '../providers/videos.dart';
import '../main.dart';
import 'package:wakelock/wakelock.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    Wakelock.disable();
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
                Provider.of<Videos>(context, listen: false).fetchAndSetVideos(
                  (value as Map)['orderValue'],
                  (value as Map)['sortValue'],
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
          padding: EdgeInsets.only(
            top: 2,
            bottom: Platform.isAndroid ? 5 : 25,
            left: 15,
            right: 15,
          ),
          child: TabBar(
              indicatorColor: Colors.amber,
              labelColor: const Color.fromARGB(255, 255, 186, 8),
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.black54,
              controller: tabController,
              tabs: const [
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
            const MovieListScreen(),
            ChannelsScreen(),
            const AuthorsScreen(),
          ],
        ),
      ),
    );
  }
}
