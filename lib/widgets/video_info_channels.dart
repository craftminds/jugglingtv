import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/videos_db.dart';
import '../providers/channels.dart';

class VideoInfoChannels extends StatelessWidget {
  const VideoInfoChannels({
    Key? key,
    required this.loadedvideo,
  }) : super(key: key);

  final Video loadedvideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FutureBuilder<List<VideoChannel>>(
          //TODO: put it in separate widget and play with the text style (oval background)
          future: Provider.of<VideoChannels>(context)
              .fetchChannelsForVideo(loadedvideo.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Text(
                    '${snapshot.data?[index].channelName as String}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        //fontSize: 20,
                        height: 3,
                        background: Paint()
                          ..strokeWidth = 18.0
                          ..color = Color.fromARGB(255, 255, 186, 8)
                          ..style = PaintingStyle.stroke
                          ..strokeJoin = StrokeJoin.round),
                  );
                },
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
