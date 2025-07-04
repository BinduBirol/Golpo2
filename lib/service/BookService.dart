import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DTO/Book.dart';
import '../utils/ImageCacheHelper.dart';

class BookService {
  static List<Book>? _cachedBooks;
  static const _offlineFileName = 'offlineBooks.json';
  static const _booksPrefsKey = 'cachedBooks';

  /// Fetch books: from local file (mobile/desktop) or assets (web)
  static Future<List<Book>> fetchBooks() async {
    if (_cachedBooks != null) return _cachedBooks!;

    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString(_booksPrefsKey);

    if (cachedJson != null) {
      final List<dynamic> data = json.decode(cachedJson);
      _cachedBooks = data.map((json) => Book.fromJson(json)).toList();
      return _cachedBooks!;
    }

    if (kIsWeb) {
      // ✅ Web fallback
      final jsonString = await rootBundle.loadString(
        'assets/data/books/offlineBooks.json',
      );
      final List<dynamic> data = json.decode(jsonString);
      _cachedBooks = data.map((json) => Book.fromJson(json)).toList();
      await _saveBooksToPrefs(); // cache it for future
      return _cachedBooks!;
    }

    // ✅ Mobile/Desktop fallback
    final file = await _getOfflineJsonFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> data = json.decode(content);
      _cachedBooks = data.map((json) => Book.fromJson(json)).toList();
      await _saveBooksToPrefs(); // cache it for future
      return _cachedBooks!;
    }

    throw Exception('No offline books found.');
  }

  /// Get local file for storing offlineBooks.json
  static Future<io.File> _getOfflineJsonFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/booksJson';
    await io.Directory(path).create(recursive: true);
    return io.File('$path/$_offlineFileName');
  }

  /// Update a book's userActivity and save to SharedPreferences
  static Future<void> updateUserActivity(
    int bookId,
    UserActivity updatedActivity,
  ) async {
    if (_cachedBooks == null) return;

    final index = _cachedBooks!.indexWhere((book) => book.id == bookId);
    if (index != -1) {
      final updatedBook = _cachedBooks![index].copyWithUserActivity(
        updatedActivity,
      );
      _cachedBooks![index] = updatedBook;
      await _saveBooksToPrefs();
    }
  }

  /// Save current book list to SharedPreferences (optional backup)
  static Future<void> _saveBooksToPrefs() async {
    if (_cachedBooks == null) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _cachedBooks!.map((book) => book.toJson()).toList();
    prefs.setString(_booksPrefsKey, json.encode(jsonList));
  }

  /// Cache book cover images
  static Future<void> cacheCovers(List<Book> books) async {
    for (int i = 0; i < books.length; i++) {
      final localPath = await ImageCacheHelper.cacheBookCover(
        books[i].imageUrl,
        books[i].id,
      );
      books[i] = books[i].copyWith(cachedImagePath: localPath);
    }
  }

  /// Optional: Clear cached file (mobile/desktop only)
  static Future<void> clearOfflineCache() async {
    if (kIsWeb) return;
    final file = await _getOfflineJsonFile();
    if (await file.exists()) {
      await file.delete();
    }
    _cachedBooks = null;
  }
}
