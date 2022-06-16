import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import '../db/local_database.dart';
import '../models/db_query_helper.dart';

class Videos with ChangeNotifier {
  List<Video> _items = [];

  List<Video> get items {
    return [...items];
  }

// Read all the videos
  Future<List<Video>> fetchAndSetVideos(OrderBy order, Sort sort) async {
    //TODO: add try&catch
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
    _items = loadedVideos;
    return _items;
  }

// Read only the videos within the given channel
  Future<List<Video>> fetchAndSetVideosByChannel(
      String channelName, OrderBy order, Sort sort) async {
    //TODO: add try&catch
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
      loadedVideos = await LocalDatabase.instance.readAllVideos(order, sort);
    } catch (error) {
      throw (error);
    }
    _items = loadedVideos;
    return _items;
  }

  Video readVideoById(int id) {
    return _items.firstWhere((vid) => vid.id == id);
  }

  //Returns the list of videos by author, works on the copy of the list from the database, not querying the database
  List<Video> readVideoByAuthor(int authorID) {
    return _items.where((element) => element.authorID == authorID).toList();
  }
}
