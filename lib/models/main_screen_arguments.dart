class MainScreenArguments {
  final String? channel;
  final List<String>? tags;
  final MainScreenMode? mainScreenMode;

  MainScreenArguments({this.channel, this.tags, this.mainScreenMode});
}

enum MainScreenMode {
  allVideos,
  channel,
  tags,
}
