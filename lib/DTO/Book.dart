class Book {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String genre;
  final String publishedYear;

  final bool isMyFavorite;
  final int price;
  final double rating;
  final String viewCount;

  final String storyTime;
  final String commentsCount;
  final List<String> category;

  Book({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.genre,
    required this.publishedYear,
    required this.isMyFavorite,
    required this.price,
    required this.rating,
    required this.viewCount,
    required this.storyTime,
    required this.commentsCount,
    required this.category,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['imageUrl'] ?? '',
      author: json['author'] ?? 'Unknown Author',
      genre: json['genre'] ?? 'Unknown Genre',
      publishedYear: json['publishedYear']?.toString() ?? 'Unknown Year',
      isMyFavorite: json['isMyFavorite'] ?? false,
      price: json['price'] ?? 0,
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] ?? 0.0),
      viewCount: json['viewCount'] ?? '0',
      storyTime: json['storyTime'] ?? '0 min',
      commentsCount: json['commentsCount'] ?? '0',
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}
