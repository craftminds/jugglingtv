import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:jugglingtv/screens/channels_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:filter_list/filter_list.dart';

import '../widgets/movie_list.dart';
import '../db/local_database.dart';
import '../models/videos_db.dart';
import '../providers/videos.dart';
import '../widgets/app_drawer.dart';
import '../providers/tags.dart';
import '../widgets/movie_list_builder.dart';

/* this part should be replaces for other source videos
// get movies from the file - maybe move that to another file?
Future<List<Movie>> fetchMovies() async {
  final String response = await rootBundle.loadString('assets/videos.json');
  //print(response);
  return compute(parseMovies, response);
}

//decode from json to list iterable by dart
List<Movie> parseMovies(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Movie>((json) => Movie.fromJson(json)).toList();
}
*/

class MovieListScreen extends StatefulWidget {
  static const routeName = '/';
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late List<Video> videos;
  bool _isLoading = false;
  var _isInit = true;
  List<Tag> allTags = [];
  List<Tag>? selectedTagList = [];

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      //print('Fetching videos...');
      Provider.of<Tags>(context).fetchAndSetTags().then((tags) {
        allTags = tags;
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    LocalDatabase.instance.close();
    super.dispose;
  }

  // Future refreshVideos() async {
  //   setState(() => isLoading = true);
  //   this.videos = await LocalDatabase.instance.readAllVideos();
  //   //this.videos = await Videos.

  //   setState(() => isLoading = false);
  // }
  void _openFilterDialog() async {
    await FilterListDialog.display<Tag>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Select Tags',
      height: 500,
      listData: allTags,
      selectedListData: selectedTagList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ContolButtonType.Reset],
      onItemSearch: (user, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return user.name.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectedTagList = List.from(list!);
        });
        Navigator.pop(context);
      },

      /// uncomment below code to create custom choice chip
      // choiceChipBuilder: (context, item, isSelected) {
      //   return Container(
      //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //     decoration: BoxDecoration(
      //         border: Border.all(
      //       color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
      //     )),
      //     child: Text(
      //       item.name,
      //       style: TextStyle(
      //           color: isSelected ? Colors.blue[300] : Colors.grey[300]),
      //     ),
      //   );
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final videosData = Provider.of<Videos>(context);
    // final r = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Center(
          child: Image.asset(
            "assets/images/logo.png",
            //fit: BoxFit.cover,
            scale: 1.5,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Container(
            height: 60.0,
            child: Column(
              children: [
                const Divider(thickness: 1.0, height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      autofocus: false,
                      child: Column(
                        children: [
                          Icon(Icons.tag,
                              color:
                                  Theme.of(context).textTheme.caption?.color),
                          Text(
                            'Tags Filtering',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption?.color,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.fontFamily,
                            ),
                          ),
                        ],
                      ),
                      onPressed: _openFilterDialog,
                    ),
                    TextButton(
                      autofocus: false,
                      child: Column(
                        children: [
                          Icon(Icons.tv,
                              color:
                                  Theme.of(context).textTheme.caption?.color),
                          Text(
                            'Channels',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption?.color,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.fontFamily,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => Navigator.pushNamed(
                          context, ChannelsScreen.routeName),
                    ),
                  ],
                ),
              ],
            ),
          )),
      body: MovieListBuilder(),
    );
  }
}
