class Book {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String genre;
  final String publishedYear;

  final int price;
  double rating;
  int viewCount;

  final int storyTime;
  int commentsCount;
  final List<String> category;

  UserActivity userActivity; // <-- nested user activity

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.genre,
    required this.publishedYear,
    required this.price,
    required this.rating,
    required this.viewCount,
    required this.storyTime,
    required this.commentsCount,
    required this.category,
    required this.userActivity,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['imageUrl'] ?? '',
      author: json['author'] ?? 'Unknown Author',
      genre: json['genre'] ?? 'Unknown Genre',
      publishedYear: json['publishedYear']?.toString() ?? 'Unknown Year',
      price: json['price'] ?? 0,
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] ?? 0.0),
      viewCount: json['viewCount'] ?? 0,
      storyTime: json['storyTime'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0, // fix here: int expected
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      userActivity: json['userActivity'] != null
          ? UserActivity.fromJson(json['userActivity'])
          : UserActivity(isMyFavorite: false, isUnlocked: false),
    );
  }
}

class UserActivity {
  bool isMyFavorite;
  bool isUnlocked;

  UserActivity({required this.isMyFavorite, required this.isUnlocked});

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      isMyFavorite: json['isMyFavorite'] ?? false,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  // Add copyWith method to allow immutable updates
  UserActivity copyWith({
    bool? isMyFavorite,
    bool? isUnlocked,
  }) {
    return UserActivity(
      isMyFavorite: isMyFavorite ?? this.isMyFavorite,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
