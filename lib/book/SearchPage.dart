import 'package:flutter/material.dart';
import '../DTO/Book.dart';
import '../book/BookDetailPage.dart';

class SearchPage extends StatefulWidget {
  final List<Book> allBooks;

  const SearchPage({Key? key, required this.allBooks}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];

  void _onSearch(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredBooks = widget.allBooks
          .where((book) => book.title.toLowerCase().contains(lowerQuery))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Books")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearch,
              decoration: InputDecoration(
                hintText: "Search by title...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredBooks.isEmpty
                ? const Center(child: Text("No results yet. Type and search."))
                : ListView.builder(
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      return ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailPage(book: book),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
