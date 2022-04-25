import 'package:flutter/material.dart';
import '../providers/tags.dart';
import '../models/videos_db.dart';
import 'package:provider/provider.dart';

class TagsScreen extends StatefulWidget {
  static const routeName = '/tags-screen';
  const TagsScreen({Key? key}) : super(key: key);

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel_presentation_sharp),
              label: 'Clear Selection'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchString = value;
                });
              },
              //controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                constraints: const BoxConstraints(maxHeight: double.infinity),
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<List<Tag>>(
                    future: Provider.of<Tags>(context).fetchAndSetTags(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("${snapshot.error}"),
                        );
                      } else if (snapshot.hasData) {
                        return Wrap(
                          runAlignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          spacing: 20.0,
                          children: <Widget>[
                            for (var item in snapshot.data!.where((tag) => tag
                                .name
                                .toLowerCase()
                                .contains(searchString.toLowerCase())))
                              Text(
                                item.name,
                                style: TextStyle(
                                    //fontWeight: FontWeight.w600,
                                    //fontSize: 20,
                                    height: 3,
                                    background: Paint()
                                      ..strokeWidth = 18.0
                                      ..color =
                                          const Color.fromARGB(255, 255, 186, 8)
                                      ..style = PaintingStyle.stroke
                                      ..strokeJoin = StrokeJoin.round),
                              )
                          ],
                          //
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
          ],
        ),
      ),
    );
  }
}
