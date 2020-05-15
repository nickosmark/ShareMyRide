import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/RidesModel.dart';

class RideResultCard extends StatelessWidget {

  final RidesModel ridesModel;
  final Function(RidesModel) onPressed;
  final Color darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);

  RideResultCard({
    this.ridesModel,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    UserModel userModel = ridesModel.driver;
    String from, to;
    double rating = double.parse((userModel.rating).toStringAsFixed(1));
    if(ridesModel.fromText.length > 400)
      from = ridesModel.fromText.substring(0, 37) + "...";
    else
      from = ridesModel.fromText;

    if(ridesModel.toText.length > 400)
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
            SizedBox(child: Text(from), height: 35),
            Icon(
                Icons.arrow_downward
            ),
            SizedBox(child: Text(to), height: 35),
            SizedBox(
              height: 3.0,
            ),
            RaisedButton(
              color: darkBlueColor,
              textColor: Colors.white,
              child: Text('Show Details'),
              onPressed: () {
                onPressed(ridesModel);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
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