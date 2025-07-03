import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageCacheHelper {
  static Future<String?> cacheBookCover(String imageUrl, int bookId) async {
    try {
      if (kIsWeb) {
        return imageUrl; // use network image directly
      }

      final uri = Uri.parse(imageUrl);
      final ext = p.extension(uri.path); // .jpg, .png, etc.

      final appDir = await getApplicationDocumentsDirectory();
      final bookDir = Directory(p.join(appDir.path, 'books', '$bookId'));

      if (!(await bookDir.exists())) {
        await bookDir.create(recursive: true);
      }

      final filePath = p.join(bookDir.path, 'cover$ext');
      final file = File(filePath);

      // ✅ If file already exists, return its path
      if (await file.exists()) {
        return file.path;
      }

      // ⬇️ Download and save
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (e) {
      print('Error caching book cover: $e');
    }

    return null;
  }
}
