class Bite {
  final String id;
  final String restaurantName;
  final String imageUrl;
  final double rating;
  final DateTime date;
  final bool isSaved;

  Bite({
    required this.id,
    required this.restaurantName,
    required this.imageUrl,
    required this.rating,
    required this.date,
    this.isSaved = false,
  });

  Bite copyWith({
    String? id,
    String? restaurantName,
    String? imageUrl,
    double? rating,
    DateTime? date,
    bool? isSaved,
  }) {
    return Bite(
      id: id ?? this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      date: date ?? this.date,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
