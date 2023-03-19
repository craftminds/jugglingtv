import 'package:flutter/material.dart';
import 'package:jugglingtv/models/videos_db.dart';
import 'package:jugglingtv/widgets/video_info.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share_plus/share_plus.dart';

import '../providers/videos.dart';
import '../widgets/video_item.dart';
import '../widgets/video_info.dart';
import '../providers/favorites.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);
  static const routeName = '/video';

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  //todo: the favorites icon should be as a separate stateful widget - no need to reload the whole screen just for that one little gem
  @override
  Widget build(BuildContext context) {
    final videoId = ModalRoute.of(context)?.settings.arguments as int;

    final loadedvideo =
        Provider.of<Videos>(context, listen: false).readVideoById(videoId);
    Provider.of<Favorites>(context, listen: false).isFavorite(loadedvideo.id);

    bool isVideoFavorite = Provider.of<Favorites>(context).favorite;

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
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Share.share(loadedvideo.videoUrl, subject: loadedvideo.title);
                },
                child: const Icon(Icons.share, color: Colors.amber),
              )),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // if the movie is in the favorite list after tapping delete it
                  if (isVideoFavorite) {
                    Provider.of<Favorites>(context, listen: false)
                        .deleteFromFavoriteVideoTable(loadedvideo.id)
                        .then(
                          (value) =>
                              print("ID of the removed video is: $value"),
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.amber.shade50,
                        content: const Text(
                          "Removed from favorite videos",
                          style: TextStyle(color: Colors.black),
                        ),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            Provider.of<Favorites>(context, listen: false)
                                .insertFavoriteVideo(loadedvideo.id)
                                .then(
                                  (value) => print('Added once again: $value'),
                                );
                          },
                          textColor: Colors.red,
                        ),
                      ),
                    );
                    setState(() {
                      Provider.of<Favorites>(context, listen: false)
                          .isFavorite(loadedvideo.id);
                      print('Deleted movie state: $isVideoFavorite');
                    });
                  } else {
                    Provider.of<Favorites>(context, listen: false)
                        .insertFavoriteVideo(loadedvideo.id)
                        .then(
                          (value) => print("ID of the added video is: $value"),
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.amber.shade50,
                        content: const Text(
                          "Added to favorite videos",
                          style: TextStyle(color: Colors.black),
                        ),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            Provider.of<Favorites>(context, listen: false)
                                .deleteFromFavoriteVideoTable(loadedvideo.id)
                                .then(
                                  (value) => print('Deleted: $value'),
                                );
                          },
                          textColor: Colors.black,
                        ),
                      ),
                    );
                    setState(() {
                      Provider.of<Favorites>(context, listen: false)
                          .isFavorite(loadedvideo.id);
                      print('Added movie state: $isVideoFavorite');
                    });
                  }
                },
                child: isVideoFavorite
                    ? const Icon(Icons.favorite_outlined, color: Colors.amber)
                    : const Icon(Icons.favorite_border_outlined,
                        color: Colors.amber),
              )),
        ],
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
