import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/videos_db.dart';

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
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          subtitle: Text(
            description,
            softWrap: true,
          ),
          backgroundColor: Colors.black87,
          title: Text(
            name,
            textAlign: TextAlign.end,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1?.fontFamily),
          ),
        ),
      ),
    );
  }
}
