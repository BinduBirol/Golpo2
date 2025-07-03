class Book {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String genre;
  final String publishedYear;
  final int price;
  final double rating;
  final int viewCount;
  final int storyTime;
  final int commentsCount;
  final List<String> category;
  final UserActivity userActivity;

  String? cachedImagePath; // mutable field for local use (not persisted)

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
    this.cachedImagePath,
  });

  /// Factory constructor from JSON
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
      commentsCount: json['commentsCount'] ?? 0,
      category:
          (json['category'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      userActivity: json['userActivity'] != null
          ? UserActivity.fromJson(json['userActivity'])
          : UserActivity(isMyFavorite: false, isUnlocked: false),
    );
  }

  /// To JSON (exclude cachedImagePath)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'author': author,
      'genre': genre,
      'publishedYear': publishedYear,
      'price': price,
      'rating': rating,
      'viewCount': viewCount,
      'storyTime': storyTime,
      'commentsCount': commentsCount,
      'category': category,
      'userActivity': userActivity.toJson(),
    };
  }

  /// Copy Book with optional overrides (including cachedImagePath)
  Book copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    String? author,
    String? genre,
    String? publishedYear,
    int? price,
    double? rating,
    int? viewCount,
    int? storyTime,
    int? commentsCount,
    List<String>? category,
    UserActivity? userActivity,
    String? cachedImagePath,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      publishedYear: publishedYear ?? this.publishedYear,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      viewCount: viewCount ?? this.viewCount,
      storyTime: storyTime ?? this.storyTime,
      commentsCount: commentsCount ?? this.commentsCount,
      category: category ?? this.category,
      userActivity: userActivity ?? this.userActivity,
      cachedImagePath: cachedImagePath ?? this.cachedImagePath,
    );
  }

  /// Copy only user activity safely (shortcut)
  Book copyWithUserActivity(UserActivity newUserActivity) {
    return copyWith(userActivity: newUserActivity);
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
  UserActivity copyWith({bool? isMyFavorite, bool? isUnlocked}) {
    return UserActivity(
      isMyFavorite: isMyFavorite ?? this.isMyFavorite,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {'isMyFavorite': isMyFavorite, 'isUnlocked': isUnlocked};
  }
}
