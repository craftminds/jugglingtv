import 'package:flutter/material.dart';
import 'package:jugglingtv/providers/connectivity.dart';

import 'package:overlay_support/overlay_support.dart';
import '../screens/main_tabs_screen.dart';
import 'package:jugglingtv/screens/movies_list_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import './screens/video_screen.dart';
import './db/local_database.dart';
import 'models/videos_db.dart';
import 'providers/videos.dart';
import 'providers/video_channel.dart';
import 'providers/video_tag.dart';
import 'providers/channels.dart';
import './screens/channels_screen.dart';

import 'providers/tags.dart';
import './screens/authors_screen.dart';
import './screens/author_screen.dart';
import './providers/authors.dart';
import './screens/about_screen.dart';
import './providers/favorites.dart';
import './screens/favorites_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final mainTabsScreenKey = GlobalKey<MainTabsScreenState>();

  @override
  Widget build(BuildContext context) {
    const appTitle = 'jugglingtv';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocalDatabase.instance),
        ChangeNotifierProvider(create: (context) => Videos()),
        ChangeNotifierProvider(create: (context) => VideoChannels()),
        ChangeNotifierProvider(create: (context) => VideoTags()),
        ChangeNotifierProvider(create: (context) => Channels()),
        ChangeNotifierProvider(create: (context) => Tags()),
        ChangeNotifierProvider(create: (context) => Authors()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => Favorites()),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          //TODO: work on theme for the app, the font, the colors etc.
          title: appTitle,
          theme: ThemeData(
              primaryColor: Colors.lightGreen,
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
                bodyText2: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.normal,
                  wordSpacing: 3.0,
                ),
                caption: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.normal,
                ),
              ),
              // fontFamily: 'Quicksand',

              scaffoldBackgroundColor: const Color.fromARGB(255, 251, 251, 251),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 251, 251, 251),
                // foregroundColor: Color.fromARGB(255, 251, 251, 251),
                foregroundColor: Colors.black54,
              )),
          home: MainTabsScreen(key: mainTabsScreenKey),
          routes: {
            MovieListScreen.routeName: (context) => const MovieListScreen(),
            VideoScreen.routeName: (context) => const VideoScreen(),
            ChannelsScreen.routeName: (context) => ChannelsScreen(),
            AuthorsScreen.routeName: (context) => const AuthorsScreen(),
            AuthorScreen.routeName: (context) => const AuthorScreen(),
            AboutScreen.routeName: (context) => const AboutScreen(),
            FavoritesScreen.routeName: (context) => const FavoritesScreen(),
            //TagsScreen.routeName: ((context) => const TagsScreen()),
          },
        ),
      ),
    );
  }
}
