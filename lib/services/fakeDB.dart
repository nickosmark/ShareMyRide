//Random User to display on Screen.
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/UserRide.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FakeDB {

  static RidesModel fakeRide = new RidesModel(fromText: 'from', toText: 'to', randPoints: [new LatLng(38.236785, 23.94523)], toLatLng: new LatLng(37.236785, 23.44523), dateTime: new DateTime(2020), driver: fakeUser);
  static UserModel fakeUser = new UserModel(name: 'name', gender: Gender.male, phone: '699999999', email: 'covid19@gmail.com', carInfo: 'mercedes bench', rating: 1.1);
  static ReviewModel reviewModel = new ReviewModel(imageUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
    name: 'John Ioannides',
    phone: '6999999999',
    reviewText: 'God bless Trump!! America is the best country in the world but this driver is shit.',
    rating: 5.0,);
//  static final UserModel randomDriver39 = UserModel(
//    name: 'Odhgouliss',
//    gender: Gender.female,
//    phone: '+30 699999999',
//    email: 'info@covid19.who',
//    carInfo: 'Mercedez Benz ;) ',
//    reviewsList: [
//      //user 52
//      ReviewModel(
//        imageUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
//        name: 'Alexis Tsipras',
//        reviewText:
//        'polu kalos DRIVER',
//        rating: 5.0,
//      ),
//      //
//      //User 17
//      ReviewModel(
//        imageUrl: 'https://randomuser.me/api/portraits/men/17.jpg',
//        name: 'Rey Mysterio',
//        reviewText: 'This driver is the SHIT',
//        rating: 5.0,
//      ),
//      //User 6
//      ReviewModel(
//        imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
//        name: 'Donald Trump',
//        reviewText: 'covfefe DRIVER',
//        rating: 2.0,
//      ),
//    ],
//    ridesList: [],
//  );
//
//  static final RidesModel ride55 = RidesModel(
//    randPoints: [new LatLng(38.236785, 23.94523), new LatLng(38.324466, 23.844654), new LatLng(38.787454, 23.563211), new LatLng(37.67887, 23.454545), new LatLng(37.67887, 22.45)],
//    toLatLng: new LatLng(38.67887, 23.45),
//    dateTime: new DateTime(2020),
//    driver: randomDriver39,
//  );
//
//  static final UserModel randomPassenger12 = UserModel(
//    name: 'Tsampatsidis',
//    gender: Gender.female,
//    phone: '+30 699999999',
//    email: 'info@covid19.who',
//    carInfo: 'Mercedez Benz ;) ',
//    reviewsList: [
//      //user 52
//      ReviewModel(
//        imageUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
//        name: 'John Ioannides',
//        reviewText:
//        'God bless Trump!! America is the best country in the world but this driver is shit.',
//        rating: 5.0,
//      ),
//      //
//      //User 17
//      ReviewModel(
//        imageUrl: 'https://randomuser.me/api/portraits/men/17.jpg',
//        name: 'Kuriakos Mitsotakis',
//        reviewText: 'Menoume Spiti gia na exoume tin ugeia mas',
//        rating: 5.0,
//      ),
//      //User 6
//      ReviewModel(
//        imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
//        name: 'Donald Trump',
//        reviewText: 'covfefe',
//        rating: 2.0,
//      ),
//    ],
//    ridesList: [
//      UserRide(
//        status: Status.pending,
//        isDriver: false,
//        ride: ride55,
//        fellowTraveler: randomDriver39,
//      ),
//    ],
//  );
//

}

