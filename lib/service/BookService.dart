import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/services.dart';
import 'package:golpo/DTO/category.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DTO/Book.dart';
import '../DTO/Genre.dart';
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

    try {
      String jsonString;

      if (kIsWeb) {
        // 🌐 Web: Always load from asset
        jsonString = await rootBundle.loadString(
          'assets/data/books/offlineBooks.json',
        );
      } else {
        // 📱 Mobile/Desktop
        final file = await _getOfflineJsonFile();

        if (file != null && await file.exists()) {
          // ✅ Local file exists: read it
          jsonString = await file.readAsString();
        } else {
          // 🆘 Local file missing: fallback to asset and optionally copy
          jsonString = await rootBundle.loadString(
            'assets/data/books/offlineBooks.json',
          );
          await copyAssetJsonToLocalStorage(); // ensure future availability
        }
      }

      final List<dynamic> data = json.decode(jsonString);
      _cachedBooks = data.map((json) => Book.fromJson(json)).toList();
      await _saveBooksToPrefs();
      return _cachedBooks!;
    } catch (e, stack) {
      print('❌ Error while fetching books: $e');
      print('📛 Stack trace:\n$stack');
      rethrow;
    }
  }

  /// Get local file for storing offlineBooks.json
  static Future<io.File?> _getOfflineJsonFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/booksJson';

      // Attempt to create the directory if it doesn't exist
      final directory = io.Directory(path);
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      final filePath = '$path/$_offlineFileName';
      print('📄 Offline JSON file path: $filePath');

      return io.File(filePath);
    } catch (e, stack) {
      print('❌ Failed to get offline JSON file: $e');
      print('📛 Stack trace:\n$stack');
      return null; // or rethrow or handle as needed
    }
  }

  static Future<bool> copyAssetJsonToLocalStorage() async {
    try {
      if (kIsWeb) return false;

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/booksJson';
      final file = io.File('$path/$_offlineFileName');

      // If already exists, skip copying
      if (await file.exists()) {
        print('✅ Local JSON already exists at ${file.path}');
        return true;
      }

      // Ensure directory exists
      await io.Directory(path).create(recursive: true);

      // Load JSON from assets
      final jsonString = await rootBundle.loadString(
        'assets/data/books/offlineBooks.json',
      );

      // Write to local file
      await file.writeAsString(jsonString);

      print('📁 Copied asset JSON to local path: ${file.path}');
      return true;
    } catch (e, stack) {
      print('❌ Failed to copy asset JSON: $e');
      print('📛 Stack trace:\n$stack');
      return false;
    }
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
  /// Clear cached file and memory (mobile/desktop only)
  static Future<void> clearOfflineCache() async {
    if (kIsWeb) return;

    try {
      final file = await _getOfflineJsonFile();
      if (file != null && await file.exists()) {
        await file.delete();
        print('🗑 Offline cache file deleted.');
      }
      _cachedBooks = null;
    } catch (e) {
      print('❌ Failed to clear offline cache: $e');
    }
  }

  static const _categoryKey = 'cached_categories';
  static const _genreKey = 'cached_genres';

  /// Load genres from cache or assets
  static Future<List<String>> loadGenres() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_genreKey);

    if (cached != null) {
      return List<String>.from(json.decode(cached));
    }

    final jsonStr = await rootBundle.loadString('assets/data/essentials/genres.json');
    final jsonData = json.decode(jsonStr);
    final genres = List<String>.from(jsonData);  // <-- here

    // Save to cache
    await prefs.setString(_genreKey, json.encode(genres));
    return genres;
  }

  /// Load categories from cache or assets
  static Future<List<Category_>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_categoryKey);

    if (cached != null) {
      final List<dynamic> cachedList = json.decode(cached);
      return cachedList.map((e) => Category_.fromJson(e)).toList();
    }

    final jsonStr = await rootBundle.loadString('assets/data/essentials/categories.json');
    final List<dynamic> jsonList = json.decode(jsonStr);

    final categories = jsonList.map((e) => Category_.fromJson(e)).toList();

    // Store as simple string list
    await prefs.setString(_categoryKey, json.encode(categories.map((c) => c.name).toList()));

    return categories;
  }


  /// Clear both caches
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_categoryKey);
    await prefs.remove(_genreKey);
  }



}
