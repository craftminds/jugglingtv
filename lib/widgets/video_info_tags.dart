import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/videos_db.dart';
import '../providers/video_tag.dart';

class VideoInfoTags extends StatelessWidget {
  const VideoInfoTags({
    Key? key,
    required this.loadedvideo,
  }) : super(key: key);

  final Video loadedvideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<VideoTag>>(
          future:
              Provider.of<VideoTags>(context).fetchTagsForVideo(loadedvideo.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              return Wrap(
                runAlignment: WrapAlignment.start,
                direction: Axis.horizontal,
                spacing: 20.0,
                children: <Widget>[
                  for (var item in snapshot.data!)
                    Text(
                      item.tagName,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          //fontSize: 20,
                          height: 3,
                          background: Paint()
                            ..strokeWidth = 18.0
                            ..color = const Color.fromARGB(255, 255, 186, 8)
                            ..style = PaintingStyle.stroke
                            ..strokeJoin = StrokeJoin.round),
                    ),
                ],
                //
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 1.0,
                ),
              );
            }
          }),
    );
  }
}
