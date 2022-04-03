import 'package:flutter/material.dart';
//import '../models/movies.dart';
import '../models/videos_db.dart';
import 'movie_item.dart';

class MovieList extends StatelessWidget {
  const MovieList({Key? key, required this.movies}) : super(key: key);
  final List<Video> movies;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieItem(
          id: movies[index].id,
          title: movies[index].title,
          author: movies[index].authorName,
          commentsNo: movies[index].commentsNo,
          duration: movies[index].duration,
          thumbnailUrl: movies[index].thumbnailUrl,
          views: movies[index].views,
        );
      },
    );
  }
}
