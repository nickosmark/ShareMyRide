import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/RidesModel.dart';

class RideResultCard extends StatelessWidget {

  final RidesModel ridesModel;
  final Function(RidesModel) onPressed;

  RideResultCard({
    this.ridesModel,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    UserModel userModel = ridesModel.driver;
    return Card(
      color: Colors.yellow[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: new NetworkImage(userModel.getUrlFromNameHash(genderInput: userModel.gender)),
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
            Text(ridesModel.fromText),
            Icon(
                Icons.arrow_downward
            ),
            Text(ridesModel.toText),
            SizedBox(
              height: 3.0,
            ),
            FlatButton(
              color: Colors.black,
              textColor: Colors.white,
              child: Text('Request Ride'),
              onPressed: () {
                onPressed(ridesModel);
              },//onPressed
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(userModel.rating.toString()),
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