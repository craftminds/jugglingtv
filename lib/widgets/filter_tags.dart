import 'package:flutter/material.dart';
import '../models/videos_db.dart';
import 'package:filter_list/filter_list.dart';
import 'package:provider/provider.dart';
import '../providers/tags.dart';

class FilterTags extends StatelessWidget {
  FilterTags({
    Key? key,
    this.allTagsList,
    this.selectedTagList,
  }) : super(key: key);

  final List<Tag>? allTagsList;
  List<Tag>? selectedTagList;

  @override
  Widget build(BuildContext context) {
    final tags = Provider.of<Tags>(context, listen: false);

    return FilterListWidget<Tag>(
      listData: allTagsList,
      themeData: FilterListThemeData(
        context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        headerTheme: HeaderThemeData(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            searchFieldBackgroundColor: Colors.black12),
      ),
      selectedListData: tags.filteredItems,
      validateSelectedItem: (list, val) {
        //selectedTagList = list as List<Tag>;
        if (list!.contains(val)) {
          tags.setFilteredTags(list);
        }
        print(tags.filteredItems.length);

        ///  identify if item is selected or not
        return list.contains(val);
      },
      choiceChipLabel: (item) {
        return item!.name;
      },
      onItemSearch: (tag, query) {
        return tag.name.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {},
    );
  }
}
