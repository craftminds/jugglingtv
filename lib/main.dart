import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';

import './movie_list.dart';
import 'models/movies.dart';

// get movies from the file
Future<List<Movie>> fetchMovies() async {
  final String response = await rootBundle.loadString('assets/videos.json');
  //print(response);
  return compute(parseMovies, response);
}

//decode from json to list iterable by dart
List<Movie> parseMovies(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Movie>((json) => Movie.fromJson(json)).toList();
}

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
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Image.asset(
            "assets/images/logo.png",
            //fit: BoxFit.cover,
            scale: 1.5,
          ),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return MovieList(movies: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
