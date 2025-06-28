class Book {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String genre;
  final String publishedYear;

  Book({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.genre,
    required this.publishedYear,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['imageUrl'] ?? '',
      author: json['author'] ?? 'Unknown Author',
      genre: json['genre'] ?? 'Unknown Genre',
      publishedYear: json['publishedYear']?.toString() ?? 'Unknown Year',
    );
  }
}
