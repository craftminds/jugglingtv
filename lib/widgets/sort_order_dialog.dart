import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/main_screen_arguments.dart';
import '../models/videos_db.dart';
import '../models/db_query_helper.dart';
import '../screens/movies_list_screen.dart';
import '../providers/videos.dart';

class SortOrderDialog extends StatefulWidget {
  SortOrderDialog({Key? key}) : super(key: key);

  @override
  State<SortOrderDialog> createState() => _SortOrderDialogState();
}

class _SortOrderDialogState extends State<SortOrderDialog> {
  late DropdownListItem dropdownSortByValue;
  late DropdownListItem dropdownOrderValue;
  List<DropdownListItem> orderByDropdownList = <DropdownListItem>[
    DropdownListItem(caption: OrderBy.title.caption, orderValue: OrderBy.title),
    DropdownListItem(caption: OrderBy.views.caption, orderValue: OrderBy.views),
    DropdownListItem(
        caption: OrderBy.duration.caption, orderValue: OrderBy.duration),
    DropdownListItem(
        caption: OrderBy.commentsNo.caption, orderValue: OrderBy.commentsNo),
    DropdownListItem(caption: OrderBy.year.caption, orderValue: OrderBy.year),
  ];
  List<DropdownListItem> sortByDropdownList = <DropdownListItem>[
    DropdownListItem(caption: Sort.asc.caption, sortValue: Sort.asc),
    DropdownListItem(caption: Sort.desc.caption, sortValue: Sort.desc),
  ];

  void initState() {
    // dropdownSortByValue = sortByDropdowList[0];
    // on init the value should be updated with the last used value
    if (Provider.of<Videos>(context, listen: false).orderValue.value == "") {
      dropdownOrderValue = orderByDropdownList[0];
    } else {
      //find the index of the chosen orderValue value
      dropdownOrderValue = orderByDropdownList[orderByDropdownList.indexWhere(
          (element) =>
              Provider.of<Videos>(context, listen: false).orderValue ==
              element.orderValue)];
    }
    if (Provider.of<Videos>(context, listen: false).sortValue.value == "") {
      dropdownOrderValue = orderByDropdownList[0];
    } else {
      //find the index of the sortValue value
      dropdownSortByValue = sortByDropdownList[sortByDropdownList.indexWhere(
          (element) =>
              Provider.of<Videos>(context, listen: false).sortValue ==
              element.sortValue)];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(15),
      child: Container(
        height: 180,
        width: 200,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text(
                    //   "Select filter",
                    //   style: TextStyle(
                    //       fontStyle:
                    //           Theme.of(context).textTheme.headline1!.fontStyle),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(
                            fit: FlexFit.loose, child: Text('Order by')),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: orderByDropdownList
                                .map((DropdownListItem item) {
                              return DropdownMenuItem<DropdownListItem>(
                                value: item,
                                child: Text(
                                  item.caption,
                                  style: Theme.of(context).textTheme.bodyText1!,
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
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(
                            fit: FlexFit.loose, child: Text('View in')),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items:
                                sortByDropdownList.map((DropdownListItem item) {
                              return DropdownMenuItem<DropdownListItem>(
                                value: item,
                                child: Text(
                                  item.caption,
                                  style: Theme.of(context).textTheme.bodyText1!,
                                ),
                              );
                            }).toList(),
                            value: dropdownSortByValue,
                            onChanged: (DropdownListItem? newValue) {
                              setState(() {
                                dropdownSortByValue = newValue!;
                              });
                            },
                          ),
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
                          onPressed: () => Navigator.pop(context, {
                            'sortValue':
                                Provider.of<Videos>(context, listen: false)
                                    .sortValue,
                            'orderValue':
                                Provider.of<Videos>(context, listen: false)
                                    .orderValue,
                          }),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'sortValue': dropdownSortByValue.sortValue,
                              'orderValue': dropdownOrderValue.orderValue,
                            });
                            // print(dropdownOrderValue
                            //     .caption);
                            // print(dropdownSortByValue
                            //     .caption);
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.amber),
                          ),
                          // style: ButtonStyle(overlayColor: MaterialStateProperty<Color>(Colors.amber)),
                        ),
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
