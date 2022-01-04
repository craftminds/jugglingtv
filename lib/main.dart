import 'package:flutter/material.dart';
import 'models/movies.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';

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

    return const MaterialApp(
      title: appTitle,
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
            return MoviesList(movies: snapshot.data!);
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

class MoviesList extends StatelessWidget {
  const MoviesList({Key? key, required this.movies}) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    //using simple builder to create the tiles with the movie pictures
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Container(
            height: 80,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  movies[index].thumbnailUrl,
                ),
                child: const Padding(padding: EdgeInsets.all(10)),
              ),
              title: Text(movies[index].title),
              subtitle: Text(movies[index].author),
              trailing: FittedBox(
                child: Container(
                  width: 80,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.visibility_outlined),
                        const SizedBox(width: 5),
                        Text(movies[index].views),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.av_timer),
                        const SizedBox(width: 5),
                        Text(movies[index].duration),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.comment),
                        const SizedBox(width: 5),
                        Text(movies[index].commentsNo),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
