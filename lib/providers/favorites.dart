import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import '../db/local_database.dart';

class Favorites with ChangeNotifier {
  List<Video> _items = [];

  List<Video> get items {
    return [..._items];
  }

  Future<List<Video>> fetchVideos() async {
    try {
      _items = await LocalDatabase.instance.readFavoriteVideos();
    } catch (error) {
      throw (error);
    }
    return _items;
  }
}
