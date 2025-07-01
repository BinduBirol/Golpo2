import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/widgets/number_formatter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../DTO/Book.dart';

class BookGridView extends StatelessWidget {
  final List<Book> books;
  final void Function(Book) onBookTap;

  const BookGridView({Key? key, required this.books, required this.onBookTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String localeCode = Localizations.localeOf(context).languageCode;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
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
                            return Center(
                              child: SizedBox(
                                width: 150,
                                child: Lottie.asset(
                                  'assets/animations/image_loading.json',
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : const Center(
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
                          NumberFormat.decimalPattern(
                            localeCode,
                          ).format(book.rating),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Top right - price or free badge if locked
                if (!book.userActivity.isUnlocked)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: book.price == 0
                            ? Colors.green.withOpacity(0.9)
                            : Colors.deepOrange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: book.price == 0
                          ? const Text(
                              'Free',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.coins,
                                  size: 10,
                                  color: Colors.yellow[700],
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  NumberFormat.decimalPattern(
                                    localeCode,
                                  ).format(book.price),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                if (book.userActivity.isUnlocked &&
                    book.userActivity.isMyFavorite)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.favorite, color: Colors.red, size: 12),
                  ),

                if (book.userActivity.isUnlocked &&
                    !book.userActivity.isMyFavorite)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.menu_book, color: Colors.grey, size: 12),
                  ),
                // Bottom: Read count + title with gradient overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 14,
                      left: 8,
                      right: 8,
                      bottom: 6,
                    ),
                    decoration: const BoxDecoration(
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
                              NumberFormatter.formatCount(
                                book.viewCount,
                                localeCode,
                              ),
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
