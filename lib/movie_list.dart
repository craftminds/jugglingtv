import 'package:flutter/material.dart';
import './models/movies.dart';

class MovieList extends StatelessWidget {
  const MovieList({Key? key, required this.movies}) : super(key: key);
  final List<Movie> movies;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  movies[index].thumbnailUrl,
                  fit: BoxFit.fill,
                ),
              ),
              title: Text(
                movies[index].title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(movies[index].author),
              trailing: FittedBox(
                child: Container(
                  width: 120,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.visibility_outlined),
                        const SizedBox(width: 5),
                        Text(movies[index].views),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.av_timer),
                        const SizedBox(width: 5),
                        Text(movies[index].duration),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.comment),
                        const SizedBox(width: 5),
                        Text(movies[index].commentsNo),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
