import 'package:flutter/material.dart';
import 'package:jugglingtv/models/main_screen_arguments.dart';
import '../models/videos_db.dart';
import 'package:provider/provider.dart';
import '../providers/authors.dart';
import '../widgets/author_list.dart';

class AuthorListBuilder extends StatelessWidget {
  const AuthorListBuilder({
    Key? key,
    required this.args,
  }) : super(key: key);
  final AuthorsScreenArguments args;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Author>>(
        future: Provider.of<Authors>(context)
            .fetchAndSetAuthors(args.order!, args.sort!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return AuthorList(authors: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
                strokeWidth: 1.0,
              ),
            );
          }
        });
  }
}
