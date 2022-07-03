import 'package:flutter/material.dart';
import 'package:jugglingtv/models/db_query_helper.dart';
import 'package:provider/provider.dart';
import '../providers/videos.dart';
import '../models/videos_db.dart';
import './movie_list.dart';
import '../models/main_screen_arguments.dart';

class MovieListBuilder extends StatelessWidget {
  MovieListBuilder({
    Key? key,
    required this.args,
  }) : super(key: key);
  final MainScreenArguments args;

  Future<List<Video>> _viewListViewMode(
      BuildContext context, MainScreenMode mode) {
    switch (mode) {
      case MainScreenMode.allVideos:
        {
          var videoItems = Provider.of<Videos>(context, listen: false).items;
          if (videoItems.isEmpty) {
            print("database read");
            return Provider.of<Videos>(context)
                .fetchAndSetVideos(args.orderBy!, args.sort!);
          } else {
            print("items read");
            return Future(() => videoItems);
          }
        }

      case MainScreenMode.channel:
        {
          return Provider.of<Videos>(context).fetchAndSetVideosByChannel(
              args.channel!, args.orderBy!, args.sort!);
        }
      case MainScreenMode.tags:
        {
          //TODO: correct for tags filtering
          return Provider.of<Videos>(context)
              .fetchAndSetVideosByChannel("Clubs", OrderBy.author, Sort.asc);
        }

      default:
        {
          // return all videos if wrong arguments are passed

          return Provider.of<Videos>(context)
              .fetchAndSetVideos(args.orderBy!, args.sort!);
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
