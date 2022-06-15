import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import '../db/local_database.dart';
import '../models/db_query_helper.dart';

class Authors with ChangeNotifier {
  List<Author> _items = [];

  List<Author> get items {
    return [..._items];
  }

// Read all the Authors
  Future<List<Author>> fetchAndSetAuthors(String order, Sort sort) async {
    //TODO: add try&catch
    List<Author> loadedAuthors = [];
    if (order == "") {
      order = AuthorFields.name;
    }
    // the same as above but for sorting
    if (sort.value == "") {
      sort = Sort.asc;
    }
    try {
      loadedAuthors = await LocalDatabase.instance.readAllAuthors(order, sort);
    } catch (error) {
      error;
      rethrow;
    }
    _items = loadedAuthors;
    return _items;
  }

  Author readAuthorById(int id) {
    return _items.firstWhere((author) => author.id == id);
  }
}


//select video.author_id , author.name, count(*)  FROM video,author WHERE video.author_id = author.id group by video.author_id