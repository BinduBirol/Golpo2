import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../DTO/Book.dart';

class BookService {
  // Private static cache variable
  static List<Book>? _cachedBooks;

  static Future<List<Book>> fetchBooks() async {
    // Return cached data if available
    if (_cachedBooks != null) {
      return _cachedBooks!;
    }

    // Else load from JSON asset
    final jsonString = await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> data = json.decode(jsonString);
    _cachedBooks = data.map((json) => Book.fromJson(json)).toList();
    return _cachedBooks!;
  }
}
