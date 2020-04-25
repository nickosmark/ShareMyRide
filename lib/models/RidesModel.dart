import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';

enum Status{
  pending,
  confirmed,
  completed,
}

class RidesModel{
  double fromWhere;
  double toWhere;
  Status status;
  UserModel fellowTraveler;

}