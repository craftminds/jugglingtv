import 'package:flutter/foundation.dart';

// names of all the tables in DB
const String tableAuthor = 'authors';
const String tableChannel = 'channel';
const String tableTag = 'tag';
const String tableVideo = 'video1';
const String tableVideoChannel = 'video_channel_1';
const String tableVideoTag = 'video_tag';
const String tableCountries = 'countries';

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
    imageUrl,
    fullName,
    noFollowers,
    videoViews,
    profileViews,
    hometown,
    country,
  ];
  static const String id = 'id';
  static const String name = 'name';
  static const String imageUrl = 'image_url';
  static const String fullName = 'full_name';
  static const String noFollowers = 'no_followers';
  static const String videoViews = 'video_views';
  static const String profileViews = 'profile_views';
  static const String hometown = 'hometown';
  static const String country = 'country';
  static const String moviesCount = 'movies_count';
}

class Author {
  final int id;
  final String name;
  final String imageUrl;
  final String fullName;
  final int noFollowers;
  final int videoViews;
  final int profileViews;
  final String hometown;
  final String country;
  final String countryId;
  int moviesCount;

  Author({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.fullName,
    required this.noFollowers,
    required this.videoViews,
    required this.profileViews,
    required this.hometown,
    required this.country,
    required this.moviesCount,
    required this.countryId,
  });

  static Author fromJson(Map<String, Object?> json) => Author(
        id: json[AuthorFields.id] as int,
        name: json[AuthorFields.name] as String,
        imageUrl: json[AuthorFields.imageUrl] as String,
        fullName: json[AuthorFields.fullName] as String,
        noFollowers: json[AuthorFields.noFollowers] as int,
        videoViews: json[AuthorFields.videoViews] as int,
        profileViews: json[AuthorFields.profileViews] as int,
        hometown: json[AuthorFields.hometown] as String,
        country: json[AuthorFields.country] as String,
        moviesCount: json[AuthorFields.moviesCount] == null
            ? 0
            : json[AuthorFields.moviesCount] as int,
        countryId: json[CountriesFields.idCountry] as String,
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
  //final int id;
  final String name;
  final String imageUrl;
  final String description;

  const Channel({
    //required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });
  static Channel fromJson(Map<String, Object?> json) => Channel(
        name: json[ChannelFields.name] as String,
        imageUrl: json[ChannelFields.imageUrl] as String,
        description: json[ChannelFields.description] as String,
      );
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
  //final int id;
  final String name;

  const Tag({
    //required this.id,
    required this.name,
  });
  static Tag fromJson(Map<String, Object?> json) => Tag(
        name: json[TagFields.name] as String,
      );
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
    // thumbnailUrl,
    videoUrl,
    views,
    duration,
    commentsNo,
    description,
    year,
    country,
    authorId,
  ];
  static const String id = 'VID';
  static const String title = 'title';
  // static const String thumbnailUrl = 'thumbnail_url';
  static const String videoUrl = 'enc_vdoname';
  static const String views = 'viewnumber';
  static const String duration = 'duration';
  static const String commentsNo = 'com_num';
  static const String description = 'description';
  static const String year = 'adddate';
  static const String country = 'country';
  static const String authorId = 'UID';
}

class Video {
  final int id;
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
  final int authorID;
  final String authorImageUrl;

  Video({
    required this.id,
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
    required this.authorID,
    required this.authorImageUrl,
  });

  static Video fromJson(Map<String, Object?> json) {
    //format from double to min:sec format
    double addtime = json[VideosFields.duration] as double;
    String duration =
        "${(addtime / 60).floor()}:${(addtime.floor() % 60).toString().padLeft(2, "0")}";

    // return Video(
    //   id: json[VideosFields.id] as int,
    //   title: json[VideosFields.title] == null
    //       ? ''
    //       : json[VideosFields.title] as String,
    //   thumbnailUrl: "http://juggling.tv/thumb/0_${json[VideosFields.id]}.jpg",
    //   videoUrl:
    //       "http://juggling.tv/video/encoded/${json[VideosFields.videoUrl] as String}",
    //   views: json[VideosFields.views] as int,
    //   duration: duration,
    //   commentsNo: json[VideosFields.commentsNo] as int,
    //   description: json[VideosFields.description] == null
    //       ? ''
    //       : json[VideosFields.description] as String,

    //   year: DateTime.parse("2019-07-31 00:00:00.000000"),
    //   // year: DateTime.parse(json[VideosFields.year] as String),
    //   // year: json[VideosFields.year] as DateTime,
    //   country: json[VideosFields.country] == null
    //       ? ' '
    //       : json[VideosFields.country] as String,
    //   authorName: json[AuthorFields.name] == null
    //       ? ''
    //       : json[AuthorFields.name] as String,
    //   authorID: json[VideosFields.authorId] as int,
    //   authorImageUrl: json[AuthorFields.imageUrl]
    //       as String, //for the easiness of having that info inside the video screen - other solution is to get list of author earlier to have that info ready from the local storage not from file
    // );
    return Video(
      id: json[VideosFields.id] as int,
      title: json[VideosFields.title] == null
          ? ''
          : json[VideosFields.title] as String,
      thumbnailUrl: "http://juggling.tv/thumb/0_${json[VideosFields.id]}.jpg",
      videoUrl:
          "http://juggling.tv/video/encoded/${json[VideosFields.videoUrl] as String}",
      views: json[VideosFields.views] as int,
      duration: duration,
      commentsNo: json[VideosFields.commentsNo] as int,
      description: json[VideosFields.description] == null
          ? ''
          : json[VideosFields.description] as String,
      year: DateTime.parse(json[VideosFields.year] as String),
      country: json[VideosFields.country] == null
          ? ' '
          : json[VideosFields.country] as String,
      authorName: json[AuthorFields.name] == null
          ? ''
          : json[AuthorFields.name] as String,
      authorID: json[VideosFields.authorId] as int,
      authorImageUrl: json[AuthorFields.imageUrl] as String,
    );
  }
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
  //final int videoId;
  final String channelName;

  const VideoChannel({
    //required this.videoId,
    required this.channelName,
  });

  static VideoChannel fromJson(Map<String, Object?> json) => VideoChannel(
        channelName: json[ChannelFields.name] as String,
      );
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
  final String tagName;

  const VideoTag({
    // required this.videoId,
    required this.tagName,
  });
  static VideoTag fromJson(Map<String, Object?> json) => VideoTag(
        tagName: json[TagFields.name] as String,
      );
}

class CountriesFields {
  static const String id = 'id';
  static const String value = 'value';
  static const String idCountry = 'idCountry';
}

class Countries {
  final String countryId;
  final String countryValue;

  const Countries({
    required this.countryId,
    required this.countryValue,
  });
}
