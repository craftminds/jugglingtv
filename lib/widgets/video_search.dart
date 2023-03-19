import 'package:flutter/material.dart';

import '../providers/videos.dart';
import 'package:provider/provider.dart';
import '../models/videos_db.dart';
import '../screens/video_screen.dart';
import './movies_list_screen/movie_list.dart';

class VideoSearch extends SearchDelegate<String> {
  final suggestionValues = ['1', '2', '3'];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, '');
        },
      );

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildSuggestions(BuildContext context) {
    final videoItems = Provider.of<Videos>(context).searchTitles(query);
    final suggestions = query.isEmpty ? <Video>[] : videoItems;
    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<Video> suggestions) => ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(VideoScreen.routeName, arguments: suggestion.id);
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              child: Image.network(
                suggestion.thumbnailUrl,
                fit: BoxFit.cover,
                //height: 30,
              ),
            ),
            title: Text(suggestion.title),
            subtitle: Text(suggestion.authorName),
          ),
        );
      });
  @override
  Widget buildResults(BuildContext context) {
    return MovieList(movies: Provider.of<Videos>(context).foundItems);
  }
}
