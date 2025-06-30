import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../DTO/Book.dart';

class BookGridView extends StatelessWidget {
  final List<Book> books;
  final void Function(Book) onBookTap;

  const BookGridView({Key? key, required this.books, required this.onBookTap})
    : super(key: key);

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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Full image
                Positioned.fill(
                  child: book.imageUrl.isNotEmpty
                      ? Image.network(
                          book.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            // While loading, show a spinner
                            return Center(
                              child: SizedBox(
                                width: 150,
                                child: Lottie.asset(
                                  'assets/animations/image_loading.json',
                                ),
                              ),
                            );
                          },

                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),

                          /*    errorBuilder: (_, __, ___) => Container(
                            color: Theme.of(
                              context,
                            ).appBarTheme.foregroundColor,
                            width: double.infinity,
                            height: double.infinity,
                            child: SvgPicture.asset(
                              'assets/svg/book_cover/1.svg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                    */
                        )
                      : Center(
                          child: Icon(Icons.book, size: 50, color: Colors.grey),
                        ),
                ),

                // Top left - rating
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 10, color: Colors.yellow[700]),
                        const SizedBox(width: 2),
                        Text(
                          book.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Top right - Premium badge
                if (book.price == 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Free',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                if (book.price > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.coins,
                            size: 10,
                            color: Colors.yellow[700],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            book.price.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Bottom stacked: Read count + Title with shared gradient background
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 14, // 👈 padding on top
                      left: 8,
                      right: 8,
                      bottom: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book,
                              color: Colors.white70,
                              size: 10,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              book.viewCount,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
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
