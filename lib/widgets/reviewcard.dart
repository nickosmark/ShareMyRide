import 'package:flutter/material.dart';

Card reviewCard(String url, String name, String review, double rating) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
    child: ListTile(
      leading: CircleAvatar(
          backgroundImage: new NetworkImage(
              url)),
      title: Text(name),
      subtitle: Text(review),
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
