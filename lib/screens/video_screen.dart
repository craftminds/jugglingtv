import 'package:flutter/material.dart';
import 'package:jugglingtv/db/local_database.dart';
import 'package:provider/provider.dart';
import '../models/videos_db.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);
  static const routeName = '/video';
  @override
  Widget build(BuildContext context) {
    final videoId = ModalRoute.of(context)?.settings.arguments as int;
    final loadedvideo = Provider.of<LocalDatabase>(context, listen: false)
        .readVideoById(videoId);
    final title = loadedvideo.then((value) => value.title);
    print(videoId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        title: Center(
          child: Image.asset(
            "assets/images/logo.png",
            //fit: BoxFit.cover,
            scale: 1.5,
          ),
        ),
      ),
      body: Container(
        child: Center(child: Text('title')),
        //TODO: make the proper video page
      ),
    );
  }
}
