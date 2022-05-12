enum OrderBy {
  title,
  views,
  duration,
  commentsNo,
  year,
  country,
  author,
}

extension OrderByExtension on OrderBy {
  String get value {
    switch (this) {
      case OrderBy.author:
        return "author";
      case OrderBy.commentsNo:
        return "comments_no";
      case OrderBy.country:
        return "country";
      case OrderBy.duration:
        return "duration";
      case OrderBy.title:
        return "title";
      case OrderBy.views:
        return "views";
      case OrderBy.year:
        return "year";
      default:
        return "";
    }
  }
}

enum Sort {
  asc,
  desc,
}

extension SortExtension on Sort {
  String get value {
    switch (this) {
      case Sort.asc:
        return "ASC";
      case Sort.desc:
        return "DESC";
      default:
        return "";
    }
  }
}
