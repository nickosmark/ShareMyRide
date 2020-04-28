//Random User to display on Screen.
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';

class FakeDB {

  //driver should call a method to create a Ride

  static final UserModel randomDriver39 = UserModel(
    id: 39,
    name: 'Odhgouliss',
    gender: Gender.female,
    phone: '+30 699999999',
    email: 'info@covid19.who',
    carInfo: 'Mercedez Benz ;) ',
    reviewsList: [
      //user 52
      ReviewModel(
        imageUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
        name: 'Alexis Tsipras',
        reviewText:
        'polu kalos DRIVER',
        rating: 5.0,
      ),
      //
      //User 17
      ReviewModel(
        imageUrl: 'https://randomuser.me/api/portraits/men/17.jpg',
        name: 'Rey Mysterio',
        reviewText: 'This driver is the SHIT',
        rating: 5.0,
      ),
      //User 6
      ReviewModel(
        imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
        name: 'Donald Trump',
        reviewText: 'covfefe DRIVER',
        rating: 2.0,
      ),
    ],
    ridesList: [],
  );

  static final RidesModel ride55 = RidesModel(
    fromWhere: 37.0,
    toWhere: 44.0,
    dateTime: null,
    driver: randomDriver39,
  );

  static final UserModel randomPassenger12 = UserModel(
    id: 12,
    name: 'Tsampatsidis',
    gender: Gender.female,
    phone: '+30 699999999',
    email: 'info@covid19.who',
    carInfo: 'Mercedez Benz ;) ',
    reviewsList: [
      //user 52
      ReviewModel(
        imageUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
        name: 'John Ioannides',
        reviewText:
        'God bless Trump!! America is the best country in the world but this driver is shit.',
        rating: 5.0,
      ),
      //
      //User 17
      ReviewModel(
        imageUrl: 'https://randomuser.me/api/portraits/men/17.jpg',
        name: 'Kuriakos Mitsotakis',
        reviewText: 'Menoume Spiti gia na exoume tin ugeia mas',
        rating: 5.0,
      ),
      //User 6
      ReviewModel(
        imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
        name: 'Donald Trump',
        reviewText: 'covfefe',
        rating: 2.0,
      ),
    ],
    ridesList: [
      UserRide(
        status: Status.pending,
        isDriver: false,
        ride: ride55,
        fellowTraveler: randomDriver39,
      ),
    ],
  );


}

