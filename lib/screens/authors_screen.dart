import 'package:flutter/material.dart';
import 'package:jugglingtv/models/main_screen_arguments.dart';
import 'package:jugglingtv/widgets/app_drawer.dart';
import 'package:jugglingtv/widgets/author_list_builder.dart';
import 'package:jugglingtv/widgets/movie_list_builder.dart';
import 'package:provider/provider.dart';
import '../providers/authors.dart';
import '../models/db_query_helper.dart';
import '../screens/channels_screen.dart';
import '../screens/movies_list_screen.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({Key? key}) : super(key: key);
  static const routeName = '/authors';

  AuthorsScreenArguments _setAuthorsScreenArguments(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments == null) {
      return AuthorsScreenArguments(
        order: 'name',
        sort: Sort.asc,
      );
    } else {
      return ModalRoute.of(context)?.settings.arguments
          as AuthorsScreenArguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    var authorsListMode = _setAuthorsScreenArguments(context);
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
      drawer: const AppDrawer(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              const Divider(thickness: 1.0, height: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    autofocus: false,
                    child: Column(
                      children: [
                        Icon(
                          Icons.video_collection,
                          color: Theme.of(context).textTheme.caption?.color,
                        ),
                        Text(
                          'Movies',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption?.color,
                            fontFamily:
                                Theme.of(context).textTheme.caption?.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.of(context)
                        .popAndPushNamed(MovieListScreen.routeName,
                            arguments: MainScreenArguments(
                              mainScreenMode: MainScreenMode.allVideos,
                              orderBy: OrderBy.title,
                              sort: Sort.asc,
                            )),
                  ),
                  TextButton(
                    autofocus: false,
                    child: Column(
                      children: [
                        Icon(Icons.tv,
                            color: Theme.of(context).textTheme.caption?.color),
                        Text(
                          'Channels',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.caption?.color,
                            fontFamily:
                                Theme.of(context).textTheme.caption?.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, ChannelsScreen.routeName),
                  ),
                  TextButton(
                    autofocus: false,
                    child: Column(
                      children: [
                        Icon(Icons.person_search, color: Colors.amber[200]),
                        Text(
                          'Authors',
                          style: TextStyle(
                            color: Colors.amber[200],
                            fontFamily:
                                Theme.of(context).textTheme.caption?.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => {},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: AuthorListBuilder(args: authorsListMode),
    );
  }
}
