import 'package:flutter/material.dart';
import 'package:jugglingtv/models/main_screen_arguments.dart';
import '../models/videos_db.dart';
import 'package:provider/provider.dart';
import '../providers/authors.dart';
import '../widgets/author_list.dart';
import '../widgets/author_item.dart';
import 'package:searchable_listview/searchable_listview.dart';

class AuthorListBuilder extends StatefulWidget {
  AuthorListBuilder({
    Key? key,
    required this.args,
  }) : super(key: key);
  final AuthorsScreenArguments args;

  @override
  State<AuthorListBuilder> createState() => _AuthorListBuilderState();
}

class _AuthorListBuilderState extends State<AuthorListBuilder> {
  final List<Author> authors = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Author>>(
        future: Provider.of<Authors>(context)
            .fetchAndSetAuthors(widget.args.order!, widget.args.sort!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchableList<Author>(
                initialList: snapshot.data!,
                filter: _filterAuthorList,
                builder: (Author author) => AuthorItem(author: author),
                emptyWidget: const EmptyView(),
                onItemSelected: (Author item) {},
                inputDecoration: InputDecoration(
                  labelText: "Search Author",
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            );

            // AuthorList(authors: snapshot.data!);
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

  List<Author> _filterAuthorList(String searchTerm) {
    print(searchTerm);
    return authors
        .where(
          (element) =>
              element.name.toLowerCase().contains(searchTerm) ||
              element.fullName.toLowerCase().contains(searchTerm),
        )
        .toList();
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('no authors found'),
      ],
    );
  }
}
