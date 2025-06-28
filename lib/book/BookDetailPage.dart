import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../DTO/Book.dart';
import '../l10n/app_localizations.dart';
import '../widgets/my_app_bar.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: book.title),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            book.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            ),
          ),

          // Bottom Gradient for readability
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
          ),

          // Text & Button at bottom
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.menu_book),
                    label: Text(AppLocalizations.of(context)!.read),
                    onPressed: () => _showToast('Reading: ${book.title}'),
                  ),
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${book.author} • ${book.genre} • ${book.publishedYear}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    book.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}