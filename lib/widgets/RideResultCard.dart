import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/services/fakeDB.dart';

class RideResultCard extends StatelessWidget {

  final String from;
  final String to;
  final UserModel userModel;

  RideResultCard({
    this.from,
    this.to,
    this.userModel
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: new NetworkImage('https://img.documentonews.gr/unsafe/1000x600/smart/http://img.dash.documentonews.gr/documento/imagegrid/2018/10/31/5bd98303cd3a18740d2cf935.jpg'),
          radius: 30.0,
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(userModel.name),
        ),
        subtitle: Column(
          children: <Widget>[
            SizedBox(
              height: 7.0,
            ),
            Text(from),
            Icon(
                Icons.arrow_downward
            ),
            Text(to),
            SizedBox(
              height: 3.0,
            ),
            FlatButton(
              color: Colors.black,
              textColor: Colors.white,
              child: Text('Request Ride'),
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