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
    // really important to format the url with %20 instead of spaces
    final videoUrl = loadedvideo.videoUrl.replaceAll(" ", "%20");
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
                color: Theme.of(context).scaffoldBackgroundColor,
                child: VideoItem(
                  videoUrl: videoUrl,
                  // videoPlayerController:
                  // VideoPlayerController.network(videoUrl),
                  autoplay: false,
                  looping: false,
                ),
              ),
              const Divider(),
              VideoInfo(
                loadedvideo: loadedvideo,
                videoYearString: videoYearString,
              )
            ],
          ),
        ),
      ),
    );
  }
}
