import 'package:flutter/material.dart';
import 'package:jugglingtv/screens/video_screen.dart';

class MovieItem extends StatelessWidget {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String author;
  final String duration;
  final int views;
  final int commentsNo;

  const MovieItem({
    Key? key,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.author,
    required this.duration,
    required this.views,
    required this.commentsNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(VideoScreen.routeName, arguments: id);
        },
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          //alignment: Alignment.center,
          child: Row(
            children: [
              //first column in the ROW
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //second column in the ROW
              Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(author),
                    ],
                  ),
                ),
              ),
              //third column in the ROW
              Flexible(
                flex: 3,
                child: FittedBox(
                  child: Container(
                    //width: 80,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.visibility_outlined),
                              const SizedBox(width: 5),
                              Text(views.toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.av_timer),
                              const SizedBox(width: 5),
                              Text(duration),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.comment),
                              const SizedBox(width: 5),
                              Text(commentsNo.toString()),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
