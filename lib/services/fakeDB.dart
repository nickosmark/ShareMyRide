//Random User to display on Screen.
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  static final UserModel randomDriver55 = UserModel(
    id: 39,
    name: 'Suppa Hot Fia',
    gender: Gender.nonBinary,
    phone: '+30 699999999',
    email: 'info@covid19.who',
    carInfo: 'Patty Car',
    reviewsList: [review1, review2, review3],
    ridesList: [],
  );

  static final RidesModel ride39 = RidesModel(
    randPoints: [new LatLng(38.236785, 23.94523), new LatLng(38.324466, 23.844654), new LatLng(38.787454, 23.563211), new LatLng(37.67887, 23.454545), new LatLng(37.67887, 22.45)],
    toLatLng: new LatLng(38.67887, 23.45),
    dateTime: new DateTime(2020, 9, 13, 12, 45),
    driver: randomDriver39,
  );

  static final RidesModel ride55 = RidesModel(
    randPoints: [new LatLng(28.236785, 23.94523), new LatLng(28.324466, 23.844654), new LatLng(28.787454, 23.563211), new LatLng(27.67887, 23.454545), new LatLng(27.67887, 22.45)],
    toLatLng: new LatLng(38.67887, 23.45),
    dateTime: new DateTime(2020, 8, 26, 23, 0),
    driver: randomDriver55,
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
        ride: ride39,
        fellowTraveler: randomDriver39,
      ),
    ],
  );

  static final ReviewModel review1 = new ReviewModel(
    imageUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
    name: 'John Ioannides',
    reviewText:
    'God bless Trump!! America is the best country in the world but this driver is shit.',
    rating: 5.0,
  );

  static final ReviewModel review2 = new ReviewModel(
    imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
    name: 'Donald Trump',
    reviewText: 'covfefe',
    rating: 2.0,
  );

  static final ReviewModel review3 = new ReviewModel(
    imageUrl: 'https://randomuser.me/api/portraits/men/17.jpg',
    name: 'Kuriakos Mitsotakis',
    reviewText: 'Menoume Spiti gia na exoume tin ugeia mas',
    rating: 5.0,
  );

  static final List<ReviewModel> randomReviewList = [review1, review2, review3];


}

