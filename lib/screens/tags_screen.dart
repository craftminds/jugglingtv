import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import '../providers/tags.dart';
import '../models/videos_db.dart';
import 'package:provider/provider.dart';
import '../widgets/filter_tags.dart';
import '../providers/tags.dart';

class TagsScreen extends StatefulWidget {
  static const routeName = '/tags-screen';
  const TagsScreen({Key? key}) : super(key: key);

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  @override
  Widget build(BuildContext context) {
    final tags = Provider.of<Tags>(context, listen: false);

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
          height: MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              20,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<List<Tag>>(
              future: Provider.of<Tags>(context).fetchAndSetTags(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  print(tags.filteredItems[0].name);
                  return Container(
                      constraints:
                          const BoxConstraints(maxHeight: double.infinity),
                      width: MediaQuery.of(context).size.width,
                      child: FilterTags(
                        allTagsList: <Tag>[
                          Tag(name: 'kendama'),
                          Tag(name: 'dama'),
                        ],
                        selectedTagList: tags.filteredItems,
                      ));
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
