import 'package:flutter/material.dart';
import 'package:jugglingtv/providers/video_channel.dart';
import 'package:jugglingtv/screens/author_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/videos_db.dart';
import 'package:provider/provider.dart';
import './video_info_channels.dart';
import './video_info_tags.dart';

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
    const double _sizedBoxHeight = 3.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  loadedvideo.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15.0),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //const Icon(Icons.visibility_outlined),
                  const SizedBox(width: 5.0),
                  Text(
                    '${loadedvideo.views} views',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14.0),
                  ),
                  Text(
                    ' • $videoYearString (${timeago.format(loadedvideo.year)})',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14.0),
                  )
                ],
              )),
              // Expanded(
              //   child: Row(
              //     children: [
              //       Text(
              //         '$videoYearString (${timeago.format(loadedvideo.year)})',
              //         style: Theme.of(context)
              //             .textTheme
              //             .caption!
              //             .copyWith(fontSize: 14.0),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
          const Divider(thickness: 2),
          const SizedBox(height: _sizedBoxHeight),
          const Text(
            'Description:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.justify,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                loadedvideo.description.replaceAll(RegExp(r'/n'), '\n'),
                softWrap: true,
                style: Theme.of(context).textTheme.bodyText2,
              )),
            ],
          ),
          const Divider(thickness: 2.0),
          const SizedBox(height: _sizedBoxHeight),
          InkWell(
            onTap: () {
              Navigator.of(context).popAndPushNamed(AuthorScreen.routeName,
                  arguments: loadedvideo.authorID);
            },
            child: Row(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(loadedvideo.authorImageUrl),
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
          ),
          const Divider(thickness: 2.0),
          const SizedBox(height: _sizedBoxHeight),
          const Text(
            'Channels:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // const SizedBox(height: 5.0),
          VideoInfoChannels(loadedvideo: loadedvideo),
          const SizedBox(height: _sizedBoxHeight),
          const Divider(thickness: 2.0),
          const SizedBox(height: _sizedBoxHeight),
          const Text(
            'Tags:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          VideoInfoTags(loadedvideo: loadedvideo)
        ],
      ),
    );
  }
}
