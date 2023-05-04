import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const routeName = '/about';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Center(
                child: Image.asset(
              "assets/images/logo.png",
              //fit: BoxFit.cover,
              scale: 1,
            ))),
        body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    '''
Hello!

This app is the copy of well known website juggling.tv. It was created by permission of the owners of the website.

It is running in archive mode and you cannot login nor add any videos (hence you can like and share - liked videos are saved only on your device).

Enjoy the moment of flashback!                                
''',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            )));
  }
}
