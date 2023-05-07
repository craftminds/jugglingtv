import 'package:flutter/material.dart';
import '../../models/videos_db.dart';
import 'favorite_movie_item.dart';

class FavoritesMovieList extends StatelessWidget {
  const FavoritesMovieList({Key? key, required this.movies}) : super(key: key);
  final List<Video> movies;
  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(
        child: Text("No favorite movies added...",
            style: TextStyle(color: Colors.black)),
      );
    } else {
      return GridView.builder(
          gridDelegate: MediaQuery.of(context).size.width < 500
              ? const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, mainAxisExtent: 100)
              : const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400, mainAxisExtent: 100),
          key: const PageStorageKey<String>('videoPage'),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return FavoriteMovieItem(
              id: movies[index].id,
              title: movies[index].title,
              author: movies[index].authorName,
              thumbnailUrl: movies[index].thumbnailUrl,
              videoUrl: movies[index].videoUrl,
            );
          });
    }
  }
}
