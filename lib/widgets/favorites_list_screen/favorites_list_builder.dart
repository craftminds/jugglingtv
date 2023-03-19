import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/videos_db.dart';
import '../../providers/favorites.dart';
import '../movies_list_screen/movie_list.dart';
import './favorites_list.dart';

class FavoritesListBuilder extends StatelessWidget {
  FavoritesListBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: Provider.of<Favorites>(context).fetchFavoriteVideos(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          return FavoritesMovieList(movies: snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 1.0,
            ),
          );
        }
      },
    );
  }
}
