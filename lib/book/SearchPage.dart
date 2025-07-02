import 'package:flutter/material.dart';
import 'package:golpo/widgets/app_bar/my_app_bar.dart';
import 'package:lottie/lottie.dart';

import '../DTO/Book.dart';
import '../book/BookDetailPage.dart';
import 'book_grid_view.dart';

class SearchPage extends StatefulWidget {
  final List<Book> allBooks;

  const SearchPage({Key? key, required this.allBooks}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];
  bool _isLoading = false;

  void _onSearch([String? _]) async {
    final query = _searchController.text.trim();

    if (query.length < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter at least 1 letter to search."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800)); // simulate delay

    final lowerQuery = query.toLowerCase();
    final results = widget.allBooks
        .where((book) => book.title.toLowerCase().contains(lowerQuery))
        .toList();

    setState(() {
      _filteredBooks = results;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: MyAppBar(title: "Search Books"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _onSearch,
                      decoration: InputDecoration(
                        hintText: "Search by title...",
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onSearch,

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: appBarTheme.backgroundColor,
                      foregroundColor: appBarTheme.foregroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: Lottie.asset(
                      'assets/animations/image_loading.json',
                      width: 300,
                      height: 300,
                    ),
                  )
                : _filteredBooks.isEmpty
                ? const Center(child: Text("No results yet. Type and search."))
                : BookGridView(
                    books: _filteredBooks,
                    onBookTap: (book) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailPage(book: book),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
