import 'package:flutter/material.dart';
import 'package:jugglingtv/models/videos_db.dart';
import 'package:jugglingtv/widgets/video_info.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/videos.dart';
import '../widgets/video_item.dart';
import '../widgets/video_info.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);
  static const routeName = '/video';

  @override
  Widget build(BuildContext context) {
    final videoId = ModalRoute.of(context)?.settings.arguments as int;
    final loadedvideo =
        Provider.of<Videos>(context, listen: false).readVideoById(videoId);
    final title = loadedvideo.title;
    final videoUrl = loadedvideo.videoUrl;
    final videoYearString = DateFormat('yyyy-MM-dd').format(loadedvideo.year);
    print(videoUrl);
    //print(videoId);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 270,
                // padding:
                //     const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                color: Colors.black,
                child: VideoItem(
                  videoPlayerController:
                      VideoPlayerController.network(videoUrl),
                  autoplay: false,
                  looping: false,
                ),
              ),
              VideoInfo(
                  loadedvideo: loadedvideo, videoYearString: videoYearString)
            ],
          ),
        ),
      ),
    );
  }
}
