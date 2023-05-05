import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/channels.dart';
import '../widgets/channel_item.dart';
import '../models/videos_db.dart';
import '../screens/authors_screen.dart';
import '../screens/movies_list_screen.dart';
import '../models/db_query_helper.dart';
import 'package:jugglingtv/models/main_screen_arguments.dart';

class ChannelsScreen extends StatelessWidget {
  static const routeName = '/channels';

  ChannelsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   iconTheme: const IconThemeData(
        //     color: Colors.black54,
        //   ),
        //   title: Center(
        //     child: Image.asset(
        //       "assets/images/logo.png",
        //       //fit: BoxFit.cover,
        //       scale: 1.5,
        //     ),
        //   ),
        // ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.only(bottom: 2),
        //   child: SizedBox(
        //     height: 80,
        //     child: Column(
        //       children: [
        //         const Divider(thickness: 1.0, height: 2.0),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           children: <Widget>[
        //             TextButton(
        //               autofocus: false,
        //               child: Column(
        //                 children: [
        //                   Icon(
        //                     Icons.video_collection,
        //                     color: Theme.of(context).textTheme.caption?.color,
        //                   ),
        //                   Text(
        //                     'Movies',
        //                     style: TextStyle(
        //                       color: Theme.of(context).textTheme.caption?.color,
        //                       fontFamily: Theme.of(context)
        //                           .textTheme
        //                           .caption
        //                           ?.fontFamily,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               onPressed: () => Navigator.of(context)
        //                   .popAndPushNamed(MovieListScreen.routeName,
        //                       arguments: MainScreenArguments(
        //                         mainScreenMode: MainScreenMode.allVideos,
        //                         orderBy: OrderBy.title,
        //                         sort: Sort.asc,
        //                       )),
        //             ),
        //             TextButton(
        //                 autofocus: false,
        //                 child: Column(
        //                   children: [
        //                     Icon(Icons.tv, color: Colors.amber[200]),
        //                     Text(
        //                       'Channels',
        //                       style: TextStyle(
        //                         color: Colors.amber[200],
        //                         fontFamily: Theme.of(context)
        //                             .textTheme
        //                             .caption
        //                             ?.fontFamily,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 onPressed: () => {}),
        //             TextButton(
        //               autofocus: false,
        //               child: Column(
        //                 children: [
        //                   Icon(
        //                     Icons.person_search,
        //                     color: Theme.of(context).textTheme.caption?.color,
        //                   ),
        //                   Text(
        //                     'Authors',
        //                     style: TextStyle(
        //                       color: Theme.of(context).textTheme.caption?.color,
        //                       fontFamily: Theme.of(context)
        //                           .textTheme
        //                           .caption
        //                           ?.fontFamily,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               onPressed: () =>
        //                   Navigator.pushNamed(context, AuthorsScreen.routeName),
        //             )
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: FutureBuilder<List<Channel>>(
      future: Provider.of<Channels>(context).fetchAndSetChannels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          //return MovieList(movies: snapshot.data!);
          return GridView(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                //childAspectRatio: 3 / 2,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 5.0),
            children: <Widget>[
              for (var item in snapshot.data!)
                ChannelItem(
                  name: item.name,
                  imageUrl: item.imageUrl,
                  description: item.description,
                )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 1.0,
            ),
          );
        }
      },
    ));
  }
}
