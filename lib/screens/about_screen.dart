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

The app is not based on the original database, as everything piece of information was webscraped by mine, I never asked for the original data.

It is run in archive mode and you cannot login nor add any videos. Not every data was scraped thus, I didn\'t try to scrape the comments or more relations and it was getting more and more complicated for me, and for the first app ever written the amount of information to be learned was really huge.

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
