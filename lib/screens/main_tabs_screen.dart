import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wakelock/wakelock.dart';
import 'package:provider/provider.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../widgets/video_search.dart';
import '../widgets/sort_order_dialog.dart';
import '../widgets/app_drawer.dart';
import '../widgets/nestedTabBar.dart';

import '../providers/videos.dart';

class MainTabsScreen extends StatefulWidget {
  MainTabsScreen({Key? key, required Key tabKey}) : super(key: key);
  static const routeName = '/';
  Key? tabKey;

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
        body: NestedTabBarView(key: widget.tabKey),
      ),
    );
  }
}
