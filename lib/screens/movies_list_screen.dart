import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../widgets/movie_list.dart';
import '../db/local_database.dart';
import '../models/videos_db.dart';
import '../providers/videos.dart';
import '../widgets/app_drawer.dart';

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
  static const routeName = '/';
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late List<Video> videos;
  bool isLoading = false;
  var _isInit = true;
  var _isLoading = false;

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      //print('Fetching videos...');
      Provider.of<Videos>(context).fetchAndSetVideos().then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    LocalDatabase.instance.close();
    super.dispose;
  }

  // Future refreshVideos() async {
  //   setState(() => isLoading = true);
  //   this.videos = await LocalDatabase.instance.readAllVideos();
  //   //this.videos = await Videos.

  //   setState(() => isLoading = false);
  // }

  @override
  Widget build(BuildContext context) {
    final videosData = Provider.of<Videos>(context);
    final r = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Center(
          child: Image.asset(
            "assets/images/logo.png",
            //fit: BoxFit.cover,
            scale: 1.5,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sort),
            label: 'Sort',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Channels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag_sharp),
            label: 'Tags',
          ),
        ],
      ),
      body: //_isLoading
          // ? const Center(child: CircularProgressIndicator())
          // : MovieList(movies: videosData.items)
//TODO: above tries to load all the data - maybe it's wrong?

          FutureBuilder<List<Video>>(
        // future: LocalDatabase.instance.readAllVideos(),
        //TODO: write a function that recognizes what filters to apply ie: channels, tags, there show be a row in the headline
        // saying what filters are applied
        future: Provider.of<Videos>(context).fetchAndSetVideos(),
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
