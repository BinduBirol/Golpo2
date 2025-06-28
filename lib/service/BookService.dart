import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../DTO/Book.dart';

class BookService {
  static Future<List<Book>> fetchBooks() async {
    final jsonString = await rootBundle.loadString('assets/data/books.json');
    final List<dynamic> data = json.decode(jsonString);
    return data.map((json) => Book.fromJson(json)).toList();
  }
}
