import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import './video_item.dart';

class VideoController extends StatefulWidget {
  VideoController({Key? key}) : super(key: key);

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  late VideoPlayerController _controller;

  void _initController(String link) {
    _controller = VideoPlayerController.network(link)
      ..initialize().then((_) {
        setState(() {});
      });
    Future<void> _onControllerChange(String link) async {
      if (_controller == null) {
        // If there was no controller, just create a new one
        _initController(link);
      } else {
        // If there was a controller, we need to dispose of the old one first
        final oldController = _controller;

        // Registering a callback for the end of next frame
        // to dispose of an old controller
        // (which won't be used anymore after calling setState)
        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          await oldController.dispose();

          // Initing new controller
          _initController(link);
        });

        // Making sure that controller is not used by setting it to null
        setState(() {
          _controller = VideoPlayerController();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VideoItem(
      videoPlayerController: _controller,
    );
  }
}
