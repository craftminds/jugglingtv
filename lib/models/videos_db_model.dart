import 'package:flutter/foundation.dart';

// names of all the tables in DB
const String tableAuthor = 'author';
const String tableChannel = 'channel';
const String tableTag = 'tag';
const String tableVideo = 'video';
const String tableVideoChannel = 'video_channel';
const String tableVideoTag = 'video_tag';

/*
CREATE TABLE author (
	id INTEGER NOT NULL, 
	name VARCHAR(50), 
	PRIMARY KEY (id), 
	UNIQUE (name)
)*/
class AuthorFields {
  static final List<String> values = [
    id,
    name,
  ];
  static const String id = 'id';
  static const String name = 'name';
}

class Author {
  final int id;
  final String name;

  const Author({
    required this.id,
    required this.name,
  });

  static Author fromJson(Map<String, Object?> json) => Author(
        id: json[AuthorFields.id] as int,
        name: json[AuthorFields.name] as String,
      );
}

/*CREATE TABLE channel (
	id INTEGER NOT NULL, 
	name VARCHAR(30), 
	image_url TEXT, 
	description TEXT, 
	PRIMARY KEY (id), 
	UNIQUE (name)
)*/
class ChannelFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String imageUrl = 'image_url';
  static const String description = 'description';
}

class Channel {
  final int id;
  final String name;
  final String imageUrl;
  final String description;

  const Channel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}

/*
CREATE TABLE tag (
	id INTEGER NOT NULL, 
	name VARCHAR(30), 
	PRIMARY KEY (id), 
	UNIQUE (name)
)*/
class TagFields {
  static const String id = 'id';
  static const String name = 'name';
}

class Tag {
  final int id;
  final String name;

  const Tag({
    required this.id,
    required this.name,
  });
}

/*CREATE TABLE video (
	id INTEGER NOT NULL, 
	title TEXT, 
	thumbnail_url VARCHAR(2048), 
	video_url VARCHAR(2048), 
	views INTEGER, 
	duration INTEGER, 
	comments_no INTEGER, 
	description TEXT, 
	year DATETIME, 
	country VARCHAR(20), 
	author_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(author_id) REFERENCES author (id)
)*/
class VideosFields {
  static final List<String> values = [
    id,
    title,
    thumbnailUrl,
    videoUrl,
    views,
    duration,
    commentsNo,
    description,
    year,
    country,
    authorId,
  ];
  static const String id = 'id';
  static const String title = 'title';
  static const String thumbnailUrl = 'thumbnail_url';
  static const String videoUrl = 'video_url';
  static const String views = 'views';
  static const String duration = 'duration';
  static const String commentsNo = 'comments_no';
  static const String description = 'description';
  static const String year = 'year';
  static const String country = 'country';
  static const String authorId = 'author_id';
}

class Video {
  final int? id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final int views;
  final String duration;
  final int commentsNo;
  final String description;
  final DateTime year;
  final String country;
  final String authorName;

  const Video({
    this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.views,
    required this.duration,
    required this.commentsNo,
    required this.description,
    required this.year,
    required this.country,
    required this.authorName,
  });

  static Video fromJson(Map<String, Object?> json) => Video(
        //id: json[VideosFields.id] as int,
        title: json[VideosFields.title] as String,
        thumbnailUrl: json[VideosFields.thumbnailUrl] as String,
        videoUrl: json[VideosFields.videoUrl] as String,
        views: json[VideosFields.views] as int,
        duration: json[VideosFields.duration] as String,
        commentsNo: json[VideosFields.commentsNo] as int,
        description: json[VideosFields.description] as String,
        year: DateTime.parse(json[VideosFields.year] as String),
        country: json[VideosFields.country] as String,
        authorName: json[AuthorFields.name]
            as String, // <- problem jest tutaj bo ta zmienna nie jest przekazywana
      );
}

/*CREATE TABLE video_channel (
	video_id INTEGER, 
	channel_id INTEGER, 
	FOREIGN KEY(video_id) REFERENCES video (id), 
	FOREIGN KEY(channel_id) REFERENCES channel (id)
)
*/
class VideoChannelFields {
  static const String videoId = 'video_id';
  static const String channelId = 'channel_id';
}

class VideoChannel {
  final int videoId;
  final int channelId;

  const VideoChannel({
    required this.videoId,
    required this.channelId,
  });
}

/*
CREATE TABLE video_tag (
	video_id INTEGER, 
	tag_id INTEGER, 
	FOREIGN KEY(video_id) REFERENCES video (id), 
	FOREIGN KEY(tag_id) REFERENCES tag (id)
)*/
class VideoTagFields {
  static const String videoId = 'video_id';
  static const String tagId = 'tag_id';
}

class VideoTag {
  final int videoId;
  final int tagId;

  const VideoTag({
    required this.videoId,
    required this.tagId,
  });
}
