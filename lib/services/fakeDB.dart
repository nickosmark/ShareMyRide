//Random User to display on Screen.
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/UserModel.dart';

class FakeDB {
  static final UserModel randomUser12 = UserModel(
    id: 12,
    name: 'Jin Sarafoglou',
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
  );
}

