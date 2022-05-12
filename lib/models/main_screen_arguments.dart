import 'db_query_helper.dart';

class MainScreenArguments {
  final String? channel;
  final List<String>? tags;
  final MainScreenMode? mainScreenMode;
  final OrderBy? orderBy;
  final Sort? sort;

  MainScreenArguments(
      {this.channel, this.tags, this.mainScreenMode, this.orderBy, this.sort});
}

enum MainScreenMode {
  allVideos,
  channel,
  tags,
}
