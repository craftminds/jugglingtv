import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import '../db/local_database.dart';

class Favorites with ChangeNotifier {
  List<Video> _items = [];
  int _insertedId = 0;
  int _count = -1;
  bool _isFavorite = false;

  List<Video> get items {
    return [..._items];
  }

  bool get favorite {
    return _isFavorite;
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
      _items = await LocalDatabase.instance.readFavoriteVideos();
    } catch (error) {
      //return -1 // replace in final version
      throw (error);
    }
    _isFavorite = true;
    notifyListeners();
    return _insertedId;
  }

  Future<int> deleteFromFavoriteVideoTable(int videoId) async {
    try {
      _count = await LocalDatabase.instance.deleteSingleFavorite(videoId);
      _items = await LocalDatabase.instance.readFavoriteVideos();
    } catch (error) {
      throw (error);
    }
    _isFavorite = false;
    notifyListeners();
    return _count;
  }

  bool isFavorite(int id) {
    _isFavorite = _items.map((e) => e.id == id).contains(true);
    return _isFavorite;
  }
}
