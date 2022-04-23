import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/channels.dart';
import '../widgets/channel_item.dart';
import '../models/videos_db.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({Key? key}) : super(key: key);
  static const routeName = '/channels';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black54,
          ),
          title: Center(
            child: Image.asset(
              "assets/images/logo.png",
              //fit: BoxFit.cover,
              scale: 1.5,
            ),
          ),
        ),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
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
