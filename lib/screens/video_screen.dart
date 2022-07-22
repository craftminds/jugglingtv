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

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);
  static const routeName = '/video';
  //arguments must be here - below it is too late for them

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  Map? videoArgs;
  int? videoId;
  Video? loadedItem;
  Video? loadedvideo;
  String? videoUrl;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        videoArgs = ModalRoute.of(context)?.settings.arguments as Map;
        videoId = videoArgs!['id'];
        print(videoId);
        loadedItem =
            Provider.of<Videos>(context, listen: false).readVideoById(videoId!);
        loadedvideo = loadedItem!;
        videoUrl = loadedItem!.videoUrl;
        if (videoUrl == null) {
          print('^^^^^^^^^^^^^^^^null');
        }
        _controller = videoArgs?['controller']
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final

    // final title = loadedvideo.title;
    // final videoUrl = loadedvideo.videoUrl;
    //TODO: workaround for the problem of the ongoing playback
    //https://stackoverflow.com/questions/58955831/flutter-video-player-dispose
    final videoYearString = DateFormat('yyyy-MM-dd').format(loadedvideo!.year);
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
                  videoPlayerController: _controller!,
                  autoplay: false,
                  looping: false,
                ),
              ),
              const Divider(),
              VideoInfo(
                loadedvideo: loadedvideo!,
                videoYearString: videoYearString,
              )
            ],
          ),
        ),
      ),
    );
  }
}
