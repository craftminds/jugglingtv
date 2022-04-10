import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/videos.dart';
import '../widgets/video_item.dart';

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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 15.0),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            //const Icon(Icons.visibility_outlined),
                            const SizedBox(width: 4.0),
                            Text(
                              '${loadedvideo.views} views',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontSize: 14.0),
                            ),
                          ],
                        )),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '$videoYearString (${timeago.format(loadedvideo.year)})',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontSize: 14.0),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )

              // Divider(),
              // Container(
              //   height: 30,
              //   child: Expanded(
              //     child: Container(
              //       alignment: Alignment.centerLeft,
              //       child: Text(title),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
