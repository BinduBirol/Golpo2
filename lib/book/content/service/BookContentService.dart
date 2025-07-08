import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../../DTO/Book.dart';
import '../../../DTO/content/Line.dart';

class BookContentService {
  /// Loads chapters from asset JSON for the given book.
  static Future<List<Chapter>> loadChapters(Book book) async {
    final assetPath = 'assets/data/books/content/content_${book.id}.json';

    try {
      final jsonString = await rootBundle.loadString(assetPath);
      return loadChaptersFromJsonString(jsonString);
    } on FlutterError {
      throw Exception("Content file not found for book ID: ${book.id}");
    } catch (e) {
      throw Exception("Failed to load chapters: $e");
    }
  }

  /// Loads chapters from local cached JSON on device,
  /// copies from asset if cache doesn't exist yet.
  static Future<List<Chapter>> loadChaptersFromLocalCache(Book book) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final bookContentDir = Directory('${appDocDir.path}/books/${book.id}');

    if (!await bookContentDir.exists()) {
      await bookContentDir.create(recursive: true);
    }

    final localJsonFile = File('${bookContentDir.path}/content_${book.id}.json');

    if (!await localJsonFile.exists()) {
      final assetJson = await rootBundle.loadString(
        'assets/books/content/content_${book.id}.json',
      );
      await localJsonFile.writeAsString(assetJson);
    }

    final jsonString = await localJsonFile.readAsString();
    return loadChaptersFromJsonString(jsonString);
  }

  /// Parses chapters from JSON string.
  static Future<List<Chapter>> loadChaptersFromJsonString(String jsonString) async {
    final jsonData = jsonDecode(jsonString);
    final List<dynamic> chapterList = jsonData['chapters'] ?? [];

    return chapterList.map((c) => Chapter.fromJson(c)).toList();
  }
}
