import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import '../widgets/author_item.dart';

class AuthorList extends StatelessWidget {
  const AuthorList({
    Key? key,
    required this.authors,
  }) : super(key: key);
  final List<Author> authors;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: authors.length,
        itemBuilder: (context, index) {
          return AuthorItem(author: authors[index]
              // id: authors[index].id,
              // name: authors[index].name,
              // imageUrl: authors[index].imageUrl,
              // fullName: authors[index].fullName,
              // moviesCount: authors[index].moviesCount,
              );
        });
  }
}
