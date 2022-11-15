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
        return "com_num";
      case OrderBy.country:
        return "country";
      case OrderBy.duration:
        return "duration";
      case OrderBy.title:
        return "title";
      case OrderBy.views:
        return "viewnumber";
      case OrderBy.year:
        return "year";
      default:
        return "";
    }
  }

//extension can't have more than one getter value? this should be a class then
  String get caption {
    switch (this) {
      case OrderBy.author:
        return "Author";
      case OrderBy.commentsNo:
        return "# of comments";
      case OrderBy.country:
        return "Country";
      case OrderBy.duration:
        return "Duration";
      case OrderBy.title:
        return "Title";
      case OrderBy.views:
        return "Views";
      case OrderBy.year:
        return "Year";
      default:
        return "";
    }
    // return [
    //   "Author",
    //   "Comments",
    //   "Country",
    //   "Duration,",
    //   "Title",
    //   "views",
    //   "Year"
    // ][index];
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

  String get caption {
    switch (this) {
      case Sort.asc:
        return "ASCENDING";
      case Sort.desc:
        return "DESCENDING";
      default:
        return "";
    }
  }
}
