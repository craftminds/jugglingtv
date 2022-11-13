import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:wakelock/wakelock.dart';

class VideoItem extends StatefulWidget {
  //final VideoPlayerController videoPlayerController;
  final String? videoUrl;
  final bool looping;
  final bool autoplay;
  //final double aspect_ratio;

  const VideoItem({
    // required this.videoPlayerController,
    this.videoUrl,
    this.looping = false,
    this.autoplay = false,
    //this.aspect_ratio = 4 / 3,
    Key? key,
  }) : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late ChewieController _chewieController;
  late Future<void> _future;
  late VideoPlayerController videoPlayerController;

  Future<void> initVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl!);
    await videoPlayerController.initialize().then(
          (value) => {
            videoPlayerController.addListener(() {
              if (videoPlayerController.value.isPlaying == true) {
                Wakelock.enable();
              } else if (videoPlayerController.value.isPlaying == false) {
                Wakelock.disable();
              }
            })
          },
        );
    setState(() {
      // print(widget.videoPlayerController.value.aspectRatio);
      // print('Width: ${widget.videoPlayerController.value.size.width}');
      // print('Height: ${widget.videoPlayerController.value.size.height}');
      _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoInitialize: true,
        materialProgressColors: ChewieProgressColors(playedColor: Colors.amber),
        autoPlay: widget.autoplay,
        looping: widget.looping,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
        ],
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: videoPlayerController.value.isInitialized
          ? FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                return AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                );
              })
          : const CircularProgressIndicator(),
    );
  }
}
