import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';

import '../models/movies.dart';
import '../widgets/movie_list.dart';

// get movies from the file - maybe move that to another file?
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

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({Key? key}) : super(key: key);

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
              child: CircularProgressIndicator(
                color: Colors.grey,
                strokeWidth: 1.0,
              ),
            );
          }
        },
      ),
    );
  }
}
