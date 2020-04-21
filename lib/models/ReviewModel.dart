import 'dart:convert';

class ReviewModel {
  String imageUrl;
  String name;
  String reviewText;
  double rating;


  ReviewModel({
    this.imageUrl,
    this.name,
    this.reviewText,
    this.rating,
  });


  ReviewModel copyWith({
    String imageurl,
    String name,
    String reviewText,
    double rating,
  }) {
    return ReviewModel(
      imageUrl: imageurl ?? this.imageUrl,
      name: name ?? this.name,
      reviewText: reviewText ?? this.reviewText,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageurl': imageUrl,
      'name': name,
      'reviewText': reviewText,
      'rating': rating,
    };
  }

  static ReviewModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ReviewModel(
      imageUrl: map['imageurl'],
      name: map['name'],
      reviewText: map['reviewText'],
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  static ReviewModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewModel(imageurl: $imageUrl, name: $name, reviewText: $reviewText, rating: $rating)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ReviewModel &&
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
