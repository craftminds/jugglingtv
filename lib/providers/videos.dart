import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import '../db/local_database.dart';

class Videos with ChangeNotifier {
  List<Video> _items = [];

  List<Video> get items {
    return [...items];
  }

  Future<List<Video>> fetchAndSetVideos() async {
    //TODO: add try&catch
    List<Video> loadedVideos = [];
    try {
      loadedVideos = await LocalDatabase.instance.readAllVideos();
    } catch (error) {
      throw (error);
    }
    _items = loadedVideos;
    return _items;
  }

  Video readVideoById(int id) {
    return _items.firstWhere((vid) => vid.id == id);
  }
}
