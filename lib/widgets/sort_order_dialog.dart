import 'package:flutter/material.dart';

import '../models/main_screen_arguments.dart';
import '../models/videos_db.dart';
import '../models/db_query_helper.dart';
import '../screens/movies_list_screen.dart';

class SortOrderDialog extends StatefulWidget {
  SortOrderDialog({Key? key}) : super(key: key);

  @override
  State<SortOrderDialog> createState() => _SortOrderDialogState();
}

class _SortOrderDialogState extends State<SortOrderDialog> {
  late DropdownListItem dropdownSortByValue;
  late DropdownListItem dropdownOrderValue;
  List<DropdownListItem> sortByDropdowList = <DropdownListItem>[
    DropdownListItem(caption: 'title', orderValue: OrderBy.title),
    DropdownListItem(caption: 'views', orderValue: OrderBy.views),
    DropdownListItem(caption: 'duration', orderValue: OrderBy.duration),
    DropdownListItem(caption: '# of comments', orderValue: OrderBy.commentsNo),
    DropdownListItem(caption: 'country of origin', orderValue: OrderBy.country),
    DropdownListItem(caption: 'date', orderValue: OrderBy.year),
  ];
  List<DropdownListItem> orderDropdowList = <DropdownListItem>[
    DropdownListItem(caption: 'ASCENDING', sortValue: Sort.asc),
    DropdownListItem(caption: 'DESCENDING', sortValue: Sort.desc),
  ];

  void initState() {
    dropdownSortByValue = sortByDropdowList[0];
    dropdownOrderValue = orderDropdowList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(15),
      child: Container(
        height: 200,
        width: 200,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 10),
              child: Column(children: <Widget>[
                Text(
                  "Select filter",
                  style: TextStyle(
                      fontStyle:
                          Theme.of(context).textTheme.headline1!.fontStyle),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Flexible(
                        fit: FlexFit.loose, child: Text('Sort by: ')),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: sortByDropdowList.map((DropdownListItem item) {
                          return DropdownMenuItem<DropdownListItem>(
                            value: item,
                            child: Text(
                              item.caption,
                            ),
                          );
                        }).toList(),
                        value: dropdownSortByValue,
                        //hint: Text('sort by'),
                        onChanged: (DropdownListItem? newValue) {
                          setState(() {
                            dropdownSortByValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Flexible(fit: FlexFit.loose, child: Text('View in ')),
                    DropdownButton(
                      items: orderDropdowList.map((DropdownListItem item) {
                        return DropdownMenuItem<DropdownListItem>(
                          value: item,
                          child: Text(
                            item.caption,
                          ),
                        );
                      }).toList(),
                      value: dropdownOrderValue,
                      onChanged: (DropdownListItem? newValue) {
                        setState(() {
                          dropdownOrderValue = newValue!;
                        });
                      },
                    ),
                    const Flexible(
                      fit: FlexFit.loose,
                      child: Text('order '),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(
                              context, MovieListScreen.routeName,
                              arguments: MainScreenArguments(
                                mainScreenMode: MainScreenMode.channel,
                                channel: 'Balls',
                                orderBy: dropdownSortByValue.orderValue,
                                sort: dropdownOrderValue.sortValue,
                              ));
                          // print(dropdownOrderValue
                          //     .caption);
                          // print(dropdownSortByValue
                          //     .caption);
                        },
                        child: const Text('Apply')),
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownListItem {
  final String caption;
  final OrderBy? orderValue;
  final Sort? sortValue;

  DropdownListItem({
    required this.caption,
    this.orderValue,
    this.sortValue,
  });
}
