import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/videos.dart';
import '../models/videos_db.dart';
import './movie_list.dart';

class MovieListBuilder extends StatelessWidget {
  const MovieListBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      // future: LocalDatabase.instance.readAllVideos(),
      //TODO: write a function that recognizes what filters to apply ie: channels, tags, there show be a row in the headline
      // saying what filters are applied
      future: Provider.of<Videos>(context).fetchAndSetVideosByChannel("Clubs"),
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
