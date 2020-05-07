import 'dart:convert';

//This Model get created when a new review is created
class ReviewModel {
  String phone;
  String imageUrl;
  String name;
  String reviewText;
  double rating;


  ReviewModel({
    this.phone,
    this.imageUrl,
    this.name,
    this.reviewText,
    this.rating,
  });


  ReviewModel copyWith({
    String phone,
    String imageUrl,
    String name,
    String reviewText,
    double rating,
  }) {
    return ReviewModel(
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      reviewText: reviewText ?? this.reviewText,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone' : phone,
      'imageUrl': imageUrl,
      'name': name,
      'reviewText': reviewText,
      'rating': rating,
    };
  }

  static ReviewModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    double rating = map['rating'].toDouble();

    return ReviewModel(
      phone: map['phone'],
      imageUrl: map['imageUrl'],
      name: map['name'],
      reviewText: map['reviewText'],
      rating: rating,
    );
  }

  String toJson() => json.encode(toMap());

  static ReviewModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewModel(phone: $phone, imageurl: $imageUrl, name: $name, reviewText: $reviewText, rating: $rating)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ReviewModel &&
        o.phone == phone &&
      o.imageUrl == imageUrl &&
      o.name == name &&
      o.reviewText == reviewText &&
      o.rating == rating;
  }

  @override
  int get hashCode {
    return imageUrl.hashCode ^
      name.hashCode ^
      reviewText.hashCode ^
      rating.hashCode;
  }
}
