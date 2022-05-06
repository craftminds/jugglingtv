import 'package:flutter/material.dart';
import '../db/local_database.dart';
import '../models/videos_db.dart';

class VideoChannels with ChangeNotifier {
  List<VideoChannel> _items = [];

  List<VideoChannel> get items {
    return [...items];
  }

  Future<List<VideoChannel>> fetchChannelsForVideo(int id) async {
    List<VideoChannel> loadedChannels = [];
    try {
      //print('Fetching the database channels data!!!!!');
      loadedChannels = await LocalDatabase.instance.readChannelsByVideoId(id);
    } catch (error) {
      throw (error);
    }
    _items = loadedChannels;
    return _items;
  }
}
