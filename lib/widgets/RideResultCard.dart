import 'package:flutter/material.dart';

class RideResultCard extends StatelessWidget {

  String from;
  String to;
  String name = 'Json Antigoniiiiiiiiiii';

  RideResultCard({
    this.from,
    this.to
  });

  @override
  Widget build(BuildContext context) {
    double height = name.length < 23 ? 29.0 : 10.0;
    return Card(
      color: Colors.yellow[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: new NetworkImage('https://img.documentonews.gr/unsafe/1000x600/smart/http://img.dash.documentonews.gr/documento/imagegrid/2018/10/31/5bd98303cd3a18740d2cf935.jpg'),
          radius: 30.0,
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(name),
        ),
        subtitle: Column(
          children: <Widget>[
            SizedBox(
              height: height,
            ),
            Text(from),
            Icon(
                Icons.arrow_downward
            ),
            Text(to),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              color: Colors.black,
              textColor: Colors.white,
              child: Text('Show more info'),
              onPressed: () {

              },//onPressed
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('1.0'),
            Icon(
              Icons.star,
              size: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}