import 'package:flutter/material.dart';
import 'package:jugglingtv/screens/video_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/connectivity.dart';

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
    bool hasInternet = Provider.of<ConnectivityProvider>(context).isOnline;
    //variable to check how to build the
    bool landscapeView = MediaQuery.of(context).size.width > 500;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
          style: BorderStyle.none,
        ),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(VideoScreen.routeName, arguments: id);
        },
        child: Container(
          //height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          //alignment: Alignment.center,
          child: Row(
            children: [
              //first column in the ROW
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  // put below into the try catch clause and give some default image in case of error or internet timeout
                  child: hasInternet
                      ? Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.signal_wifi_connected_no_internet_4_rounded,
                          color: Colors.red,
                        ),
                ),
              ),
              //second column in the ROW
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          title.trimLeft(),
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
                flex: 1,
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
