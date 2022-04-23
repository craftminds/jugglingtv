import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/videos_db.dart';
import '../screens/movies_list_screen.dart';

class ChannelItem extends StatelessWidget {
  const ChannelItem({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

  final String name;
  final String imageUrl;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            // TODO: make it with args and put the filter in there
            Navigator.of(context)
                .pushReplacementNamed(MovieListScreen.routeName);
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            name,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1?.fontFamily,
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            description,
            softWrap: true,
            maxLines: 2,
          ),
          backgroundColor: Colors.black54,
        ),
      ),
    );
  }
}
