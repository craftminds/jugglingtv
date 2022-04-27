import 'package:flutter/material.dart';
import '../db/local_database.dart';
import '../models/videos_db.dart';

class Tags with ChangeNotifier {
  List<Tag> _items = [];
  List<Tag> _filteredItems = [];

  List<Tag> get items {
    return [..._items];
  }

  List<Tag> get filteredItems {
    return [..._filteredItems];
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

  void setFilteredTags(List<Tag> filteredItems) {
    _filteredItems = filteredItems;
  }
}
