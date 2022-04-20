import 'package:flutter/material.dart';
import 'package:jugglingtv/db/local_database.dart';
import '../models/videos_db.dart';

class Channels with ChangeNotifier {
  List<Channel> _items = [];

  List<Channel> get items {
    return [...items];
  }

  Future<List<Channel>> fetchAndSetChannels() async {
    List<Channel> loadedChannels = [];
    try {
      loadedChannels = await LocalDatabase.instance.readAllChannels();
    } catch (error) {
      throw (error);
    }
    _items = loadedChannels;
    return _items;
  }
}
