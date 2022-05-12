import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:jugglingtv/models/db_query_helper.dart';
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
import '../models/main_screen_arguments.dart';

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
  late DropdownListItem dropdownSortByValue;
  String dropdownOrderValue = 'ASCENDING';
  List<DropdownListItem> sortByDropdowList = <DropdownListItem>[
    DropdownListItem('title', 'title'),
    DropdownListItem('views', 'views'),
    DropdownListItem('duration', 'duration'),
    DropdownListItem('# of comments', 'comments_no'),
    DropdownListItem('country of origin', 'country'),
    DropdownListItem('date', 'year'),
  ];

  void initState() {
    dropdownSortByValue = sortByDropdowList[0];
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
  MainScreenArguments _setMainScreenArguments(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments == null) {
      return MainScreenArguments(
        mainScreenMode: MainScreenMode.allVideos,
        channel: null,
        tags: [],
        orderBy: OrderBy.title,
        sort: Sort.asc,
      );
    } else {
      return ModalRoute.of(context)?.settings.arguments as MainScreenArguments;
    }
  }

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
    var videosListMode = _setMainScreenArguments(context);

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
        child: SizedBox(
          height: videosListMode.channel != null ? 100 : 60,
          child: Column(
            children: [
              videosListMode.channel != null
                  ? Column(children: [
                      const Divider(thickness: 1.0, height: 2.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              '${videosListMode.channel} channel',
                              style: const TextStyle(
                                //color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      const Divider(thickness: 1.0, height: 2.0),
                    ])
                  : const Divider(thickness: 1.0, height: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    autofocus: false,
                    child: Column(
                      children: [
                        Icon(Icons.tag,
                            color: Theme.of(context).textTheme.caption?.color),
                        Text(
                          'Tags Filtering',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption?.color,
                            fontFamily:
                                Theme.of(context).textTheme.caption?.fontFamily,
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
                            color: Theme.of(context).textTheme.caption?.color),
                        Text(
                          'Channels',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption?.color,
                            fontFamily:
                                Theme.of(context).textTheme.caption?.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, ChannelsScreen.routeName),
                  ),
                  TextButton(
                      autofocus: false,
                      child: Column(
                        children: [
                          Icon(Icons.sort,
                              color:
                                  Theme.of(context).textTheme.caption?.color),
                          Text(
                            'Sorting',
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
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Dialog(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.all(15),
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  color: Colors.transparent,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 0, 10),
                                        child: Column(children: <Widget>[
                                          Text(
                                            "Select filter",
                                            style: TextStyle(
                                                fontStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .fontStyle),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Text('Sort by: ')),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  items: sortByDropdowList.map(
                                                      (DropdownListItem item) {
                                                    return DropdownMenuItem<
                                                        DropdownListItem>(
                                                      value: item,
                                                      child: Text(
                                                        item.caption,
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: dropdownSortByValue,
                                                  hint: Text('sort by'),
                                                  onChanged: (DropdownListItem?
                                                      newValue) {
                                                    setState(() {
                                                      dropdownSortByValue =
                                                          newValue!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Text('View in ')),
                                              DropdownButton(
                                                items: <String>[
                                                  'ASCENDING',
                                                  'DESCENDING'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                value: dropdownOrderValue,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownOrderValue =
                                                        newValue!;
                                                  });
                                                },
                                              ),
                                              const Flexible(
                                                fit: FlexFit.loose,
                                                child: Text('order '),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    // setState(() {
                                                    //   MainScreenArguments(orderBy: ,
                                                    //   sort:

                                                    //   )
                                                    // });
                                                  },
                                                  child: const Text('Apply')),
                                            ],
                                          )
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          })),
                ],
              ),
            ],
          ),
        ),
      ),
      body: MovieListBuilder(args: videosListMode),
    );
  }
}

class DropdownListItem {
  final String name;
  final String caption;

  DropdownListItem(this.name, this.caption);
}
