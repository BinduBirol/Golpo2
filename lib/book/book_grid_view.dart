import 'package:flutter/material.dart';
import '../DTO/Book.dart';

class BookGridView extends StatelessWidget {
  final List<Book> books;
  final void Function(Book) onBookTap;

  const BookGridView({
    Key? key,
    required this.books,
    required this.onBookTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // two items per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65, // height to width ratio for tiles
      ),
      itemBuilder: (context, index) {
        final book = books[index];

        return GestureDetector(
          onTap: () => onBookTap(book),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Book Cover Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: book.imageUrl.isNotEmpty
                        ? Image.network(
                      book.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                    )
                        : Center(
                      child: Icon(Icons.book, size: 50, color: Colors.grey),
                    ),
                  ),
                ),

                // Title and maybe author
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}