import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import '../providers/tags.dart';
import '../models/videos_db.dart';
import 'package:provider/provider.dart';

class TagsScreen extends StatelessWidget {
  static const routeName = '/tags-screen';
  const TagsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tag> selectedTagList = [];
    //List<Tag> tagList;
    AppBar appBar = AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black54,
      ),
      title: Center(
        child: Image.asset(
          "assets/images/logo.png",
          //fit: BoxFit.cover,
          scale: 1.5,
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.cancel_presentation_sharp),
      //         label: 'Clear Selection'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //   ],
      //   selectedItemColor: Colors.grey,
      //   unselectedItemColor: Colors.grey,
      // ),
      body: SingleChildScrollView(
        child:
            // Column(
            //   children: [
            //     TextField(
            //       onChanged: (value) {
            //         setState(() {
            //           searchString = value;
            //         });
            //       },
            //       //controller: searchController,
            //       decoration: const InputDecoration(
            //         prefixIcon: Icon(Icons.search),
            //       ),
            //     ),
            Container(
          height:
              MediaQuery.of(context).size.height - appBar.preferredSize.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<List<Tag>>(
              future: Provider.of<Tags>(context).fetchAndSetTags(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  //tagList = snapshot.data as List<Tag>;
                  return Container(
                    constraints:
                        const BoxConstraints(maxHeight: double.infinity),
                    width: MediaQuery.of(context).size.width,
                    child: FilterListWidget<Tag>(
                      listData: snapshot.data,
                      themeData: FilterListThemeData(context,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          headerTheme: HeaderThemeData(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              searchFieldBackgroundColor: Colors.black12)),
                      selectedListData: selectedTagList,
                      validateSelectedItem: (list, val) {
                        //selectedTagList = list as List<Tag>;

                        ///  identify if item is selected or not
                        return list!.contains(val);
                      },
                      choiceChipLabel: (item) {
                        return item!.name;
                      },
                      onItemSearch: (tag, query) {
                        return tag.name
                            .toLowerCase()
                            .contains(query.toLowerCase());
                      },
                      onApplyButtonClick: (list) {
                        //selectedTagList = list as List<Tag>;
                        //TODO: it must first ask the database and then open new page with the list of movies. Filtered tags must shown when clicked maybe in the right top corner
                        print(selectedTagList);

                        //Navigator.pop(context, list);
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 1.0,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
