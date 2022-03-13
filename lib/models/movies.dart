import 'package:flutter/foundation.dart';

class Movie {
  final int id;
  final String title;
  final String videoLink;
  final String thumbnailUrl;
  final String views;
  final String duration;
  final String author;
  final String commentsNo;

  const Movie({
    required this.id,
    required this.title,
    required this.videoLink,
    required this.thumbnailUrl,
    required this.views,
    required this.duration,
    required this.author,
    required this.commentsNo,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      videoLink: json['video_link'] as String,
      thumbnailUrl: json['thumbnail'] as String,
      views: json['views'] as String,
      duration: json['duration'] as String,
      author: json['author'] as String,
      commentsNo: json['comments_no'] as String,
    );
  }
}
