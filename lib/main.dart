import 'package:flutter/material.dart';
import 'package:jugglingtv/screens/movies_list_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';
import './screens/video_screen.dart';
import './db/local_database.dart';
import 'models/videos_db.dart';
import 'providers/videos.dart';
import 'providers/channels.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'jugglingtv';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocalDatabase.instance),
        ChangeNotifierProvider(create: (context) => Videos()),
        ChangeNotifierProvider(create: (context) => VideoChannels()),
      ],
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
          ),
          // fontFamily: 'Quicksand',
        ),
        home: const MovieListScreen(),
        routes: {
          VideoScreen.routeName: (context) => const VideoScreen(),
        },
      ),
    );
  }
}
