import 'package:flutter/material.dart';
import 'package:jugglingtv/screens/movies_list_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/foundation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'jugglingtv';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        // fontFamily: 'Quicksand',
      ),
      home: const MovieListScreen(),
      routes: {},
    );
  }
}
