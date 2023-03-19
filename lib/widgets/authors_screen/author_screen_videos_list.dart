import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/videos.dart';
import '../movies_list_screen/movie_list.dart';

class AuthorScreenVideosList extends StatelessWidget {
  const AuthorScreenVideosList({Key? key, required this.authorId})
      : super(key: key);
  final int authorId;

  @override
  Widget build(BuildContext context) {
    //final authorId = ModalRoute.of(context)?.settings.arguments as int;
    final videosList =
        Provider.of<Videos>(context, listen: false).readVideoByAuthor(authorId);
    return MovieList(movies: videosList);
  }
}
