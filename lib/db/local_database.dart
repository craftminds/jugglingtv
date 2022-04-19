import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:collection/collection.dart';
import '../models/videos_db.dart';

class LocalDatabase with ChangeNotifier {
  static final LocalDatabase instance = LocalDatabase._init();

  Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  // Future<Database> _initDB(String filePath) async {
  //   final dbPath =
  //       await getDatabasesPath(); //consider using path_provider if iOS
  //   final path = join(dbPath, filePath);

  //   return await openDatabase(path, version: 1, onCreate: _createDB);
  // }
  Future<Database> _initDB() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dbPathEnglish =
        path.join(applicationDirectory.path, "scrapy_jugglingtv.db");

    bool dbExistsEnglish = await io.File(dbPathEnglish).exists();

    if (!dbExistsEnglish) {
      // Copy from asset
      ByteData data =
          await rootBundle.load(path.join("assets", "scrapy_jugglingtv.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPathEnglish).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(dbPathEnglish);
  }

// create all the tables in case the DB is not found
  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableAuthor (
	${AuthorFields.id} INTEGER NOT NULL, 
	${AuthorFields.name} VARCHAR(50), 
	PRIMARY KEY (id), 
	UNIQUE (name)
)
''');

    await db.execute('''
CREATE TABLE $tableChannel (
	${ChannelFields.id} INTEGER NOT NULL, 
	${ChannelFields.name} VARCHAR(30), 
	${ChannelFields.imageUrl} TEXT, 
	${ChannelFields.description} TEXT, 
	PRIMARY KEY (id), 
	UNIQUE (name)
)
''');
    await db.execute('''
CREATE TABLE $tableTag (
	${TagFields.id} INTEGER NOT NULL, 
	${TagFields.name} VARCHAR(30), 
	PRIMARY KEY (id), 
	UNIQUE (name)
)''');

    await db.execute('''
CREATE TABLE $tableVideo (
	${VideosFields.id} INTEGER NOT NULL, 
	${VideosFields.title} TEXT, 
	${VideosFields.thumbnailUrl} VARCHAR(2048), 
	${VideosFields.videoUrl} VARCHAR(2048), 
	${VideosFields.views} INTEGER, 
	${VideosFields.duration} INTEGER, 
	${VideosFields.commentsNo} INTEGER, 
	${VideosFields.description} TEXT, 
	${VideosFields.year} DATETIME, 
	${VideosFields.country} VARCHAR(20),
  author_id INTEGER,
	PRIMARY KEY (id), 
	FOREIGN KEY(author_id) REFERENCES author (id)
)
''');

    await db.execute('''
CREATE TABLE $tableVideoChannel (
	${VideoChannelFields.videoId} INTEGER, 
	${VideoChannelFields.channelId} INTEGER, 
	FOREIGN KEY(video_id) REFERENCES video (id), 
	FOREIGN KEY(channel_id) REFERENCES channel (id)
)
''');
    await db.execute('''
CREATE TABLE $tableVideoTag (
	${VideoTagFields.videoId} INTEGER, 
	${VideoTagFields.tagId} INTEGER, 
	FOREIGN KEY(video_id) REFERENCES video (id), 
	FOREIGN KEY(tag_id) REFERENCES tag (id)
)''');
  }

//already implemented below without the safe whereArgs declaration
  Future<Video> readVideo(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableVideo,
      columns: VideosFields.values,
      where: '${VideosFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Video.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Video>> readAllVideos() async {
    final db = await instance.database;

    //final orderBy = '${VideosFields.id} ASC';

    // final result = await db.query(
    //   tableVideo,
    //   orderBy: orderBy,
    // ); // authorID should be already joined with another table here - String should be the output, should be done with rawQuery function

    final result = await db.rawQuery(
      '''SELECT 
      $tableVideo.${VideosFields.id},
      $tableVideo.${VideosFields.title},
        $tableVideo.${VideosFields.thumbnailUrl},
        $tableVideo.${VideosFields.videoUrl},
        $tableVideo.${VideosFields.views},
        $tableVideo.${VideosFields.duration},
        $tableVideo.${VideosFields.commentsNo},
        $tableVideo.${VideosFields.description},
        $tableVideo.${VideosFields.year},
        $tableVideo.${VideosFields.country},
        $tableAuthor.${AuthorFields.name}
        FROM
        $tableVideo, $tableAuthor
        WHERE
        $tableVideo.${VideosFields.authorId} = $tableAuthor.${AuthorFields.id}
        ''',
    );
    //print(result);
    return result.map((json) => Video.fromJson(json)).toList();
  }

//this function only returns one record
  Future<Video> readVideoById(int videoId) async {
    final db = await instance.database;

    final result = await db.rawQuery(
      '''SELECT 
        $tableVideo.${VideosFields.id},
        $tableVideo.${VideosFields.title},
        $tableVideo.${VideosFields.thumbnailUrl},
        $tableVideo.${VideosFields.videoUrl},
        $tableVideo.${VideosFields.views},
        $tableVideo.${VideosFields.duration},
        $tableVideo.${VideosFields.commentsNo},
        $tableVideo.${VideosFields.description},
        $tableVideo.${VideosFields.year},
        $tableVideo.${VideosFields.country},
        $tableAuthor.${AuthorFields.name}
        FROM
        $tableVideo, $tableAuthor
        WHERE
        $tableVideo.${VideosFields.id} = $videoId AND
        $tableVideo.${VideosFields.authorId} = $tableAuthor.${AuthorFields.id}
        ''',
    );
    //print(result);
    return result.map((json) => Video.fromJson(json)).toList()[0];
    // dirty solution - takes the first found element, always should be only one though
  }

  Future<Author> readAuthor(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableAuthor,
      columns: AuthorFields.values,
      where: '${AuthorFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Author.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  //TODO: create function to read channels for a video
  Future<List<VideoChannel>> readChannelsByVideoId(int id) async {
    final db = await instance.database;

    final result = await db.rawQuery(
      '''
SELECT 
    $tableChannel.${ChannelFields.name}
    FROM
    $tableVideoChannel, $tableChannel
    WHERE
    $tableVideoChannel.${VideoChannelFields.channelId} = $tableChannel.${ChannelFields.id} AND
    $tableVideoChannel.${VideoChannelFields.videoId} = $id
''',
    );
    print(result);
    // var groupedResult = groupBy(result, (Map obj) => obj['video_id']);
    // print(groupedResult);
    return result.map((json) => VideoChannel.fromJson(json)).toList();
  }
  //TODO: create function to read tags for a video

  Future<List<VideoTag>> readTagsByVideoId(int id) async {
    final db = await instance.database;

    final result = await db.rawQuery(
      '''
SELECT 
    $tableTag.${TagFields.name}
    FROM
    $tableVideoTag, $tableTag
    WHERE
    $tableVideoTag.${VideoTagFields.tagId} = $tableTag.${TagFields.id} AND
    $tableVideoTag.${VideoTagFields.videoId} = $id
''',
    );
    print(result);
    // var groupedResult = groupBy(result, (Map obj) => obj['video_id']);
    // print(groupedResult);
    return result.map((json) => VideoTag.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
