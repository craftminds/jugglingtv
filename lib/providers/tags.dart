import 'package:flutter/material.dart';
import '../db/local_database.dart';
import '../models/videos_db.dart';

class Tags with ChangeNotifier {
  List<Tag> _items = [];

  List<Tag> get items {
    return [...items];
  }

  Future<List<Tag>> fetchAndSetTags() async {
    List<Tag> loadedTags = [];
    try {
      loadedTags = await LocalDatabase.instance.readAllTags();
    } catch (error) {
      throw (error);
    }
    _items = loadedTags;
    return _items;
  }
}
