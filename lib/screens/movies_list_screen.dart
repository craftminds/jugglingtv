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
import '../providers/videos.dart';
import '../main.dart';
import 'dart:async';

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
  static const routeName = '/movieList';
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  StreamSubscription? connection;

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
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // setState(() {
      //   _isLoading = true;
      // });
      //print('Fetching videos...');
      // Provider.of<Tags>(context).fetchAndSetTags().then((tags) {
      //   allTags = tags;
      //   _isLoading = false;
      //   //print('Number of tags: ${tags.length}');
      // });
      Provider.of<Authors>(context)
          .fetchAndSetAuthors("$tableAuthor.${AuthorFields.id}", Sort.asc);
      //     .then((value) {
      //   print(value.length);
      // });
    }
    _isInit = false;
    print("Dependecies changed!");
    super.didChangeDependencies();
  }

  // Future refreshVideos() async {
  //   setState(() => isLoading = true);
  //   this.videos = await LocalDatabase.instance.readAllVideos();
  //   //this.videos = await Videos.

  //   setState(() => isLoading = false);
  // }

  //Sets the default state of the main screen
  MainScreenArguments setMainScreenArguments(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    var videosListMode = setMainScreenArguments(context);
    var showChannels = Provider.of<Videos>(context, listen: true).viewChannel;
    String channelName = Provider.of<Videos>(context, listen: true).channel;
    bool authorsLoaded = Provider.of<Authors>(context).authorsLoaded;
    //bool isInternet = await InternetPopup().checkInternet();

    return Scaffold(
      floatingActionButton: showChannels
          ? (FloatingActionButton.extended(
              label: Text(
                'Close $channelName Channel',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              backgroundColor: Colors.amber[300],
              onPressed: () {
                print(showChannels);
                Provider.of<Videos>(context, listen: false).fetchAndSetVideos(
                  OrderBy.title,
                  Sort.asc,
                );
                setState(() {});
              },
            ))
          : Container(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: PageStorage(
        bucket: bucketGlobal,
        child: true
            ? MovieListBuilder(args: videosListMode)
            : const Center(child: Text("No internet connection")),
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
