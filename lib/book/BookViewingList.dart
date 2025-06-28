import 'package:flutter/material.dart';
import '../DTO/Book.dart';

class BookViewingList extends StatelessWidget {
  final List<Book> books;
  final void Function(Book) onBookTap;

  const BookViewingList({
    Key? key,
    required this.books,
    required this.onBookTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(maxHeight: 300), // max height for suggestions
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.imageUrl.isNotEmpty
                  ? Image.network(
                book.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : Icon(Icons.book, size: 40, color: Colors.white70),
            ),
            title: Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              book.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () => onBookTap(book),
          );
        },
      ),
    );
  }
}
