import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

import '../models/movies.dart';
import '../widgets/movie_list.dart';
import '../db/videos_database.dart';
import '../models/videos_db_model.dart';

/* this part should be replaces for other source videos
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
*/

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late List<Video> videos;
  bool isLoading = false;
  void initState() {
    super.initState();

    refreshVideos();
  }

  @override
  void dispose() {
    VideosDatabase.instance.close();
    super.dispose;
  }

  Future refreshVideos() async {
    setState(() => isLoading = true);
    this.videos = await VideosDatabase.instance.readAllVideos();

    setState(() => isLoading = false);
  }

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
      body: FutureBuilder<List<Video>>(
        future: VideosDatabase.instance
            .readAllVideos(), //place the list generation function here, Firebase, sqflite, json, whatever is the application
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            //return MovieList(movies: snapshot.data!);
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
