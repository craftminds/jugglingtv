import 'package:flutter/material.dart';
import 'package:jugglingtv/models/db_query_helper.dart';
import 'package:provider/provider.dart';
import '../providers/videos.dart';
import '../models/videos_db.dart';
import '../providers/favorites.dart';
import './movie_list.dart';
import '../models/main_screen_arguments.dart';

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
    );
  }
}
