import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import '../db/local_database.dart';

class Favorites with ChangeNotifier {
  List<Video> _items = [];
  int _insertedId = 0;
  int _count = -1;

  List<Video> get items {
    return [..._items];
  }

  Future<List<Video>> fetchFavoriteVideos() async {
    try {
      _items = await LocalDatabase.instance.readFavoriteVideos();
    } catch (error) {
      throw (error);
    }
    return _items;
  }

  Future<int> insertFavoriteVideo(int id) async {
    try {
      _insertedId = await LocalDatabase.instance.insertSingleFavorite(id);
    } catch (error) {
      //return -1 // replace in final version
      throw (error);
    }
    return _insertedId;
  }

  Future<int> deleteFromFavoriteVideoTable(int videoId) async {
    try {
      _count = await LocalDatabase.instance.deleteSingleFavorite(videoId);
    } catch (error) {
      throw (error);
    }

    return _count;
  }
}
