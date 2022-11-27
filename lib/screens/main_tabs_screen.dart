import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io' show Platform;

import '../widgets/video_search.dart';
import '../widgets/sort_order_dialog.dart';
import '../widgets/app_drawer.dart';
import '../widgets/nestedTabBar.dart';

import '../screens/movies_list_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/authors_screen.dart';
import '../providers/videos.dart';
import '../main.dart';
import '../providers/connectivity.dart';

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
    bool isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
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
        body: SingleChildScrollView(
          child: Column(children: [
            noInternetBar(isOnline),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 80,
              child: NestedTabBarView(),
            ),
          ]),
        ),
      ),
    );
  }
}

Widget noInternetBar(bool isInternet) {
  if (isInternet == true) {
    return Container();
  } else {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 5),
      color: Colors.red,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 6.00),
            child: Icon(Icons.info, color: Colors.white),
          ),
          Text("Oh no! Check internet connection...",
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
