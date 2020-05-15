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
    String from, to;
    double rating = double.parse((userModel.rating).toStringAsFixed(1));
    if(ridesModel.fromText.length > 40)
      from = ridesModel.fromText.substring(0, 37) + "...";
    else
      from = ridesModel.fromText;

    if(ridesModel.toText.length > 40)
      to = ridesModel.toText.substring(0, 37) + "...";
    else
      to = ridesModel.toText;

    return Card(
      color: Colors.yellow[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: new NetworkImage(userModel.getUrlFromNameHash(genderInput: userModel.gender)),
          radius: 28.0,
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
              child: Text('Show Details'),
              onPressed: () {
                onPressed(ridesModel);
              },//onPressed
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(rating.toString()),
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