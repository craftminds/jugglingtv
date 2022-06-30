import 'package:flutter/material.dart';
import 'package:jugglingtv/screens/author_screen.dart';
import '../models/videos_db.dart';
import 'package:flag/flag.dart';

class AuthorItem extends StatelessWidget {
  final Author author;
  // final int id;
  // final String name;
  // final String imageUrl;
  // final String fullName;
  // final int moviesCount;

  const AuthorItem({
    Key? key,
    required this.author,
    // required this.id,
    // required this.name,
    // required this.imageUrl,
    // required this.fullName,
    // required this.moviesCount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
          style: BorderStyle.none,
        ),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(AuthorScreen.routeName, arguments: author.id),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          //alignment: Alignment.center,
          child: Row(children: [
            Flexible(
              child: CircleAvatar(
                backgroundImage: NetworkImage(author.imageUrl),
                radius: 40,
              ),
              fit: FlexFit.tight,
              flex: 1,
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: author.fullName != ' '
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Row(
                                  children: [
                                    Text(
                                      author.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    author.countryId == ' '
                                        ? const SizedBox.shrink()
                                        : Flag.fromString(
                                            author.countryId.toLowerCase(),
                                            height: 18,
                                            width: 32,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Text(author.name),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Row(
                                  children: [
                                    Text(
                                      author.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    author.countryId == ' '
                                        ? const SizedBox.shrink()
                                        : Flag.fromString(
                                            author.countryId.toLowerCase(),
                                            height: 18,
                                            width: 32,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
            ),
            Flexible(
              child: Column(
                children: [
                  const Text('Movies',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  CircleAvatar(
                    child: Text(
                      '${author.moviesCount}',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    backgroundColor: Colors.amber[100],
                    radius: 25,
                  ),
                ],
              ),
              flex: 1,
              fit: FlexFit.loose,
            )
          ]),
        ),
      ),
    );
  }
}
