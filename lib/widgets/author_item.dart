import 'package:flutter/material.dart';

class AuthorItem extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;
  final String fullName;

  const AuthorItem({
    Key? key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.fullName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
          style: BorderStyle.none,
        ),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          //alignment: Alignment.center,
          child: Row(children: [
            Flexible(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 40,
                ),
                fit: FlexFit.tight,
                flex: 1),
            Flexible(
              flex: 3,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: fullName != ' '
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(name),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                                //maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )),
            )
          ]),
        ),
      ),
    );
  }
}
