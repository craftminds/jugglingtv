import 'package:flutter/material.dart';
import 'package:jugglingtv/screens/video_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/connectivity.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../providers/favorites.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteMovieItem extends StatelessWidget {
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

  void deleteFavoriteMovie(BuildContext ctx) {
    Provider.of<Favorites>(ctx, listen: false).deleteFromFavoriteVideoTable(id);
  }

  @override
  Widget build(BuildContext context) {
    bool hasInternet = Provider.of<ConnectivityProvider>(context).isOnline;
    return Slidable(
      key: UniqueKey(),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        dismissible:
            DismissiblePane(onDismissed: () => deleteFavoriteMovie(context)),
        children: [
          SlidableAction(
            onPressed: deleteFavoriteMovie,
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
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
                .pushNamed(VideoScreen.routeName, arguments: id);
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
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      child: Icon(Icons.share, color: Colors.amber),
                      onTap: () {
                        Share.share(videoUrl, subject: title);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
