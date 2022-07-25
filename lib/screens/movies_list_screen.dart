import 'package:flutter/material.dart';

import 'package:jugglingtv/models/db_query_helper.dart';
import 'package:jugglingtv/providers/authors.dart';
import 'package:jugglingtv/screens/channels_screen.dart';
import 'package:jugglingtv/widgets/sort_order_dialog.dart';
import 'package:provider/provider.dart';

import '../db/local_database.dart';
import '../models/videos_db.dart';
import '../widgets/app_drawer.dart';
import '../providers/tags.dart';
import '../widgets/movie_list_builder.dart';
import '../models/main_screen_arguments.dart';
import '../screens/authors_screen.dart';
import '../widgets/video_search.dart';

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
final bucketGlobal = PageStorageBucket();

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
  late DropdownListItem dropdownOrderValue;
  List<DropdownListItem> sortByDropdowList = <DropdownListItem>[
    DropdownListItem(caption: 'title', orderValue: OrderBy.title),
    DropdownListItem(caption: 'views', orderValue: OrderBy.views),
    DropdownListItem(caption: 'duration', orderValue: OrderBy.duration),
    DropdownListItem(caption: '# of comments', orderValue: OrderBy.commentsNo),
    DropdownListItem(caption: 'country of origin', orderValue: OrderBy.country),
    DropdownListItem(caption: 'date', orderValue: OrderBy.year),
  ];
  List<DropdownListItem> orderDropdowList = <DropdownListItem>[
    DropdownListItem(caption: 'ASCENDING', sortValue: Sort.asc),
    DropdownListItem(caption: 'DESCENDING', sortValue: Sort.desc),
  ];

  @override
  void initState() {
    dropdownSortByValue = sortByDropdowList[0];
    dropdownOrderValue = orderDropdowList[0];
    // call for all Authors for the sake of future data, single calls for one author makes no sense - too little data to get. All the authors is not that much.
    // if that applications is ever too grow more it should be considered to be done one by one

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
        //print('Number of tags: ${tags.length}');
      });
      Provider.of<Authors>(context)
          .fetchAndSetAuthors('author.id', Sort.asc)
          .then((value) {
        print(value.length);
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //LocalDatabase.instance.close();
    super.dispose;
  }

  // Future refreshVideos() async {
  //   setState(() => isLoading = true);
  //   this.videos = await LocalDatabase.instance.readAllVideos();
  //   //this.videos = await Videos.

  //   setState(() => isLoading = false);
  // }

  //Sets the default state of the main screen
  MainScreenArguments _setMainScreenArguments(BuildContext context) {
    // if it is first time opening the default setting would be as below
    if (ModalRoute.of(context)?.settings.arguments == null) {
      return MainScreenArguments(
        mainScreenMode: MainScreenMode.allVideos,
        channel: null,
        tags: [],
        orderBy: OrderBy.title,
        sort: Sort.asc,
      );
    } else {
      // otherwise (if main screen is opened from another screen) it uses arguments provided
      return ModalRoute.of(context)?.settings.arguments as MainScreenArguments;
    }
  }

// too many tags? the dialog window just doesn't open

  // void _openFilterDialog() async {
  //   await FilterListDialog.display<Tag>(
  //     context,
  //     hideSelectedTextCount: true,
  //     themeData: FilterListThemeData(context),
  //     headlineText: 'Select Tags',
  //     height: 500,
  //     listData: allTags,
  //     selectedListData: selectedTagList,
  //     choiceChipLabel: (item) => item!.name,
  //     validateSelectedItem: (list, val) => list!.contains(val),
  //     controlButtons: [ContolButtonType.Reset],
  //     onItemSearch: (user, query) {
  //       /// When search query change in search bar then this method will be called
  //       ///
  //       /// Check if items contains query
  //       return user.name.toLowerCase().contains(query.toLowerCase());
  //     },

  //     onApplyButtonClick: (list) {
  //       setState(() {
  //         selectedTagList = List.from(list!);
  //       });
  //       Navigator.pop(context);
  //     },

  //     /// uncomment below code to create custom choice chip
  //     // choiceChipBuilder: (context, item, isSelected) {
  //     //   return Container(
  //     //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //     //     decoration: BoxDecoration(
  //     //         border: Border.all(
  //     //       color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
  //     //     )),
  //     //     child: Text(
  //     //       item.name,
  //     //       style: TextStyle(
  //     //           color: isSelected ? Colors.blue[300] : Colors.grey[300]),
  //     //     ),
  //     //   );
  //     // },
  //   );
  // }

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
            scale: 1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (() {
              showSearch(context: context, delegate: VideoSearch());
            }),
            icon: const Icon(Icons.search),
            iconSize: 28,
          ),
          IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return SortOrderDialog();
                  });
                }),
            icon: const Icon(Icons.sort_by_alpha_rounded),
            iconSize: 28,
            //color: const Color.fromARGB(255, 255, 186, 8),
          )
        ],
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: SizedBox(
          height: videosListMode.channel != null ? 120 : 80,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(width: double.infinity),
                                flex: 1,
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    '${videosListMode.channel} channel',
                                    style: TextStyle(
                                      //color: Colors.amber.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      MovieListScreen.routeName,
                                      arguments: MainScreenArguments(
                                        mainScreenMode:
                                            MainScreenMode.allVideos,
                                        orderBy: OrderBy.title,
                                        sort: Sort.asc,
                                      ),
                                    );
                                    // setState(() {
                                    //   videosListMode = MainScreenArguments(
                                    //     mainScreenMode:
                                    //         MainScreenMode.allVideos,
                                    //     orderBy: OrderBy.title,
                                    //     sort: Sort.asc,
                                    //   );
                                    // });
                                  },
                                  icon: const Icon(Icons.close),
                                  //color: Colors.amber.shade800,
                                ),
                              ),
                            ],
                          )),
                      const Divider(thickness: 1.0, height: 2.0),
                    ])
                  : const Divider(thickness: 1.0, height: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // Below widget just doesn't work with that many tags have to reconsider if it makes sense to keep tags searching function

                  // TextButton(
                  //   autofocus: false,
                  //   child: Column(
                  //     children: [
                  //       Icon(Icons.tag,
                  //           color: Theme.of(context).textTheme.caption?.color),
                  //       Text(
                  //         'Tags Filtering',
                  //         style: TextStyle(
                  //           color: Theme.of(context).textTheme.caption?.color,
                  //           fontFamily:
                  //               Theme.of(context).textTheme.caption?.fontFamily,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   onPressed: _openFilterDialog,
                  // ),
                  TextButton(
                      autofocus: false,
                      child: Column(
                        children: [
                          Icon(Icons.video_collection,
                              color: Colors.amber[200]),
                          Text(
                            'Movies',
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
                      onPressed: () {}),
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
                  // TextButton(
                  //     autofocus: false,
                  //     child: Column(
                  //       children: [
                  //         Icon(Icons.sort,
                  //             color:
                  //                 Theme.of(context).textTheme.caption?.color),
                  //         Text(
                  //           'Sorting',
                  //           style: TextStyle(
                  //             color: Theme.of(context).textTheme.caption?.color,
                  //             fontFamily: Theme.of(context)
                  //                 .textTheme
                  //                 .caption
                  //                 ?.fontFamily,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  // onPressed: () => showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return StatefulBuilder(
                  //           builder: (context, setState) {
                  //         return SortOrderDialog();
                  //       });
                  //     })),
                  TextButton(
                    autofocus: false,
                    child: Column(
                      children: [
                        Icon(Icons.person_search,
                            color: Theme.of(context).textTheme.caption?.color),
                        Text(
                          'Authors',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption?.color,
                            fontFamily:
                                Theme.of(context).textTheme.caption?.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, AuthorsScreen.routeName),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: PageStorage(
        bucket: bucketGlobal,
        child: MovieListBuilder(args: videosListMode),
      ),
    );
  }
}

class DropdownListItem {
  final String caption;
  final OrderBy? orderValue;
  final Sort? sortValue;

  DropdownListItem({
    required this.caption,
    this.orderValue,
    this.sortValue,
  });
}
