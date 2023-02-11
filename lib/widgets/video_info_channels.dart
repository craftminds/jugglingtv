import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/videos_db.dart';
import '../providers/video_channel.dart';
import '../models/main_screen_arguments.dart';
import '../screens/movies_list_screen.dart';
import '../models/db_query_helper.dart';
import '../providers/videos.dart';
import '../main.dart';

class VideoInfoChannels extends StatelessWidget {
  const VideoInfoChannels({
    Key? key,
    required this.loadedvideo,
  }) : super(key: key);

  final Video loadedvideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: double.infinity),
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<VideoChannel>>(
          future: Provider.of<VideoChannels>(context)
              .fetchChannelsForVideo(loadedvideo.id),
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
                    InkWell(
                      onTap: () {
                        Provider.of<Videos>(context, listen: false)
                            .fetchAndSetVideosByChannel(
                          item.channelName,
                          OrderBy.title,
                          Sort.asc,
                        );
                        Navigator.of(context).pop();
                        MyApp.mainTabsScreenKey.currentState?.tabController
                            ?.animateTo(0);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 1.0,
                          right: 1.0,
                          top: 12.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          item.channelName,
                          style: TextStyle(
                              //fontWeight: FontWeight.w600,
                              //fontSize: 20,
                              height: 1.2,
                              background: Paint()
                                ..strokeWidth = 18.0
                                ..color = const Color.fromARGB(255, 255, 186, 8)
                                ..style = PaintingStyle.stroke
                                ..strokeJoin = StrokeJoin.round),
                        ),
                      ),
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
