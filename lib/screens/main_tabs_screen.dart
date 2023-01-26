import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wakelock/wakelock.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../widgets/video_search.dart';
import '../widgets/sort_order_dialog.dart';
import '../widgets/app_drawer.dart';

import '../screens/movies_list_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/authors_screen.dart';

import '../providers/videos.dart';

class MainTabsScreen extends StatefulWidget {
  MainTabsScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<MainTabsScreen> createState() => MainTabsScreenState();
}

class MainTabsScreenState extends State<MainTabsScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  bool hasInternet = false;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);

    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(
        () => this.hasInternet = hasInternet,
      );
    });

    Wakelock.disable();
  }

  @override
  void didChangeDependencies() {
    if (hasInternet == true) {
      Future.delayed(Duration.zero, () {
        showSimpleNotification(
          const Text("Your internet connection has dropped",
              textAlign: TextAlign.center),
          background: Colors.red.shade200,
        );
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // bool isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
    ScrollController _scrollController;
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
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            top: 2,
            // quite dirrty solution having those fixed values...
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
          // ),
        ),
      ),
    );
  }
}
