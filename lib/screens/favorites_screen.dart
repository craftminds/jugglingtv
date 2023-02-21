import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../widgets/app_drawer.dart';
import '../widgets/favorites_list_builder.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);
  static const routeName = '/favoritesList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Center(
            child: Image.asset(
              "assets/images/logo.png",
              //fit: BoxFit.cover,
              scale: 1,
            ),
          ),
          // actions: [
          //   IconButton(
          //     onPressed: (() {
          //       showSearch(context: context, delegate: VideoSearch());
          //     }),
          //     icon: const Icon(Icons.search),
          //     iconSize: 28,
          //   ),
          //   IconButton(
          //     onPressed: () => showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return StatefulBuilder(builder: (context, setState) {
          //             return SortOrderDialog();
          //           });
          //         }).then(((value) {
          //       Provider.of<Videos>(context, listen: false).fetchAndSetVideos(
          //         (value as Map)['orderValue'],
          //         (value as Map)['sortValue'],
          //       );
          //     })),
          //     icon: const Icon(Icons.sort_by_alpha_rounded),
          //     iconSize: 28,
          //     //color: const Color.fromARGB(255, 255, 186, 8),
          //   )
          // ],
        ),
        // drawer: const AppDrawer(),
        body: FavoritesListBuilder());
  }
}
