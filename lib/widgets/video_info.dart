import 'package:flutter/material.dart';
import 'package:jugglingtv/providers/channels.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/videos_db.dart';
import 'package:provider/provider.dart';

class VideoInfo extends StatelessWidget {
  const VideoInfo({
    Key? key,
    required this.loadedvideo,
    required this.videoYearString,
  }) : super(key: key);

  final Video loadedvideo;
  final String videoYearString;

  @override
  Widget build(BuildContext context) {
    const double _sizedBoxHeight = 7.0;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                loadedvideo.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 15.0),
              ),
            ],
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
          const Divider(thickness: 2),
          const SizedBox(height: _sizedBoxHeight),
          Row(
            children: [
              Expanded(
                  child: Text(
                loadedvideo.description.replaceAll(RegExp(r'/n'), '\n'),
                softWrap: true,
              )),
            ],
          ),
          const Divider(thickness: 2.0),
          const SizedBox(height: _sizedBoxHeight),
          Row(
            children: [
              CircleAvatar(
                //TODO: change for the author avatar - scrape it from the page for every author
                foregroundImage: NetworkImage(loadedvideo.thumbnailUrl),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loadedvideo.authorName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15.0),
                  ),
                  Text(
                    loadedvideo.country,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14.0),
                  )
                ],
              )
            ],
          ),
          const Divider(thickness: 2.0),
          const SizedBox(height: _sizedBoxHeight),
          const Text('Related channels:'),
          Container(
            height: 250,
            child: FutureBuilder<List<VideoChannel>>(
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
                            '#${snapshot.data?[index].channelName as String}');
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
          )
        ],
      ),
    );
  }
}
