import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import '../db/local_database.dart';
import '../models/db_query_helper.dart';

class Videos with ChangeNotifier {
  List<Video> _items = [];
  List<Video> _itemsAll = [];
  List<Video> _foundItems = [];
  var viewChannel = false;
  String channel = '';

  List<Video> get items {
    return [..._items];
  }

  //this might be redundant...
  List<Video> get itemsAll {
    return [..._itemsAll];
  }

  List<Video> get foundItems {
    return [..._foundItems];
  }

// Read all the videos
  Future<List<Video>> fetchAndSetVideos(OrderBy order, Sort sort) async {
    List<Video> loadedVideos = [];
    if (order.value == "") {
      order = OrderBy.title;
    }
    // the same as above but for sorting
    if (sort.value == "") {
      sort = Sort.asc;
    }
    try {
      loadedVideos = await LocalDatabase.instance.readAllVideos(order, sort);
    } catch (error) {
      throw (error);
    }
    _itemsAll = loadedVideos;
    _items = loadedVideos;
    viewChannel = false;
    channel = '';
    notifyListeners();
    return _items;
  }

// Read only the videos within the given channel
  Future<List<Video>> fetchAndSetVideosByChannel(
      String channelName, OrderBy order, Sort sort) async {
    List<Video> loadedVideos = [];
    //in case no ordering is given, there must default value
    if (order.value == "") {
      order = OrderBy.title;
    }
    // the same as above but for sorting
    if (sort.value == "") {
      sort = Sort.asc;
    }
    try {
      loadedVideos = await LocalDatabase.instance
          .readVideosByChannel(channelName, order, sort);
    } catch (error) {
      throw (error);
    }
    _itemsAll = loadedVideos;
    viewChannel = true;
    channel = channelName;
    notifyListeners();
    return _items;
  }

  Video readVideoById(int id) {
    return _itemsAll.firstWhere((vid) => vid.id == id);
  }

  //Returns the list of videos by author, works on the copy of the list from the database, not querying the database
  List<Video> readVideoByAuthor(int authorID) {
    return _itemsAll.where((element) => element.authorID == authorID).toList();
  }

  List<Video> searchTitles(String query) {
    _foundItems = _itemsAll
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()) ||
            element.authorName.toLowerCase().contains(query.toLowerCase()) ||
            element.country.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _foundItems;
  }
}
