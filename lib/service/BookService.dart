import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DTO/Book.dart';

class BookService {
  static List<Book>? _cachedBooks;
  static const _booksPrefsKey = 'cached_books_data';

  static Future<List<Book>> fetchBooks() async {
    if (_cachedBooks != null) return _cachedBooks!;

    final prefs = await SharedPreferences.getInstance();
    final savedBooksJson = prefs.getString(_booksPrefsKey);

    if (savedBooksJson != null) {
      // Load from saved prefs
      final List<dynamic> savedData = json.decode(savedBooksJson);
      _cachedBooks = savedData.map((json) => Book.fromJson(json)).toList();
      return _cachedBooks!;
    }

    // Load from asset if no saved data
    final jsonString = await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> data = json.decode(jsonString);
    _cachedBooks = data.map((json) => Book.fromJson(json)).toList();
    return _cachedBooks!;
  }

  static Future<void> _saveBooksToPrefs() async {
    if (_cachedBooks == null) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_cachedBooks!.map((book) => book.toJson()).toList());
    await prefs.setString(_booksPrefsKey, jsonString);
  }

  static Future<void> updateUserActivity(int bookId, UserActivity updatedActivity) async {
    if (_cachedBooks == null) return;

    final index = _cachedBooks!.indexWhere((book) => book.id == bookId);
    if (index != -1) {
      final updatedBook = _cachedBooks![index].copyWithUserActivity(updatedActivity);
      _cachedBooks![index] = updatedBook;
      await _saveBooksToPrefs(); // Save changes persistently
    }
  }
}
