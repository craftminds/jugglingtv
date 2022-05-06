import 'package:flutter/material.dart';
import '../db/local_database.dart';
import '../models/videos_db.dart';

class VideoTags with ChangeNotifier {
  List<VideoTag> _items = [];

  List<VideoTag> get items {
    return [...items];
  }

  Future<List<VideoTag>> fetchTagsForVideo(int id) async {
    List<VideoTag> loadedTags = [];
    try {
      loadedTags = await LocalDatabase.instance.readTagsByVideoId(id);
    } catch (error) {
      throw (error);
    }
    _items = loadedTags;
    return _items;
  }
}
