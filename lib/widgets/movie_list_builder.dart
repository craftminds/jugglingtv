import 'package:flutter/material.dart';
import 'package:jugglingtv/models/movie.dart';
import 'package:provider/provider.dart';
import '../providers/videos.dart';
import '../models/videos_db.dart';
import './movie_list.dart';
import '../models/main_screen_arguments.dart';

class MovieListBuilder extends StatelessWidget {
  MovieListBuilder({
    Key? key,
    MainScreenArguments? args,
  }) : super(key: key);
  MainScreenArguments args = MainScreenArguments(
    mainScreenMode: MainScreenMode.channel,
    channel: "Clubs",
  );

  Future<List<Video>> _viewListViewMode(
      BuildContext context, MainScreenMode mode) {
    print(mode);
    switch (mode) {
      case MainScreenMode.allVideos:
        {
          print("view all");
          return Provider.of<Videos>(context).fetchAndSetVideos();
        }

      case MainScreenMode.channel:
        {
          print("view by channel ${args.channel}");
          return Provider.of<Videos>(context)
              .fetchAndSetVideosByChannel(args.channel!);
        }
      case MainScreenMode.tags:
        {
          //correct for tags filtering
          return Provider.of<Videos>(context)
              .fetchAndSetVideosByChannel("Clubs");
        }
      default:
        {
          // return all videos if wrong arguments are passed
          print("default");
          return Provider.of<Videos>(context).fetchAndSetVideos();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      // future: LocalDatabase.instance.readAllVideos(),
      //TODO: write a function that recognizes what filters to apply ie: channels, tags, there show be a row in the headline
      // saying what filters are applied
      future: _viewListViewMode(context, args.mainScreenMode!),
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
