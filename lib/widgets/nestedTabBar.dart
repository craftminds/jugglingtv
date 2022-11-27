import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../screens/movies_list_screen.dart';
import '../screens/channels_screen.dart';
import '../screens/authors_screen.dart';

class NestedTabBarView extends StatefulWidget {
  NestedTabBarView({Key? key}) : super(key: key);

  @override
  State<NestedTabBarView> createState() => _NestedTabBarViewState();
}

class _NestedTabBarViewState extends State<NestedTabBarView>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        // ),
      ),
    );
  }
}
