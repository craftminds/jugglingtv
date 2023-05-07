import 'package:flutter/material.dart';
import 'package:jugglingtv/screens/video_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/connectivity.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../providers/favorites.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteMovieItem extends StatefulWidget {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String author;
  final String videoUrl;

  const FavoriteMovieItem({
    Key? key,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.author,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<FavoriteMovieItem> createState() => _FavoriteMovieItemState();
}

bool _isShown = true;

class _FavoriteMovieItemState extends State<FavoriteMovieItem> {
  void deleteFavoriteMovie(BuildContext ctx) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Not favorite anymore...'),
            content: const Text('Are you sure to remove from favorites list?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      _isShown = false;
                      Provider.of<Favorites>(ctx, listen: false)
                          .deleteFromFavoriteVideoTable(widget.id);
                    });

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('Yes', style: TextStyle(color: Colors.red))),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('No', style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    bool hasInternet = Provider.of<ConnectivityProvider>(context).isOnline;
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
          Navigator.of(context)
              .pushNamed(VideoScreen.routeName, arguments: widget.id);
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
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  // put below into the try catch clause and give some default image in case of error or internet timeout
                  child: hasInternet
                      ? Image.network(
                          widget.thumbnailUrl,
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
                          widget.title.trimLeft(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(widget.author),
                    ],
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: InkWell(
                    child: const Icon(Icons.share, color: Colors.amber),
                    onTap: () {
                      Share.share(widget.videoUrl, subject: widget.title);
                    },
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: InkWell(
                    child: const Icon(Icons.delete, color: Colors.black54),
                    onTap: () {
                      deleteFavoriteMovie(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
