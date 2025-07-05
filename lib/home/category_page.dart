import 'package:flutter/material.dart';
import 'package:golpo/widgets/app_bar/my_app_bar.dart';
import '../DTO/category.dart';
import '../book/BookDetailPage.dart';
import '../book/book_grid_view.dart';
import '../l10n/app_localizations.dart';
import '../service/BookService.dart';
import '../service/localization_helper.dart';
import '../DTO/Book.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> genres = [];
  List<Category_> categories = [];
  List<Book> allBooks = [];

  Set<String> selectedGenres = {};
  String? selectedSubcategory;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final loadedGenres = await BookService.loadGenres();
    final loadedCategories = await BookService.loadCategories();
    List<Book> loadedBooks = await BookService.fetchBooks();

    setState(() {
      genres = loadedGenres;
      categories = loadedCategories;
      allBooks = loadedBooks;
      isLoading = false;
    });
  }

  List<Book> _filteredBooks() {
    return allBooks.where((book) {
      final matchesGenre = selectedGenres.isEmpty || selectedGenres.contains(book.genre);
      final matchesSub = selectedSubcategory == null || book.category == selectedSubcategory;
      return matchesGenre && matchesSub;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final filtered = _filteredBooks();

    if (isLoading) {
      return Scaffold(
        appBar: MyAppBar(title: loc.library),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: MyAppBar(title: loc.library),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Top Genre Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.selectGenre, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: genres.map((genre) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(LocalizationHelper.localizeGenre(loc, genre)),
                          selected: selectedGenres.contains(genre),
                          onSelected: (isSelected) {
                            setState(() {
                              isSelected ? selectedGenres.add(genre) : selectedGenres.remove(genre);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ✅ Lower Section
          Expanded(
            child: Row(
              children: [
                // ⬅️ Left: Subcategory List
                Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: ListView(
                    children: categories.map((cat) {
                      final isSelected = selectedSubcategory == cat.name;
                      return ListTile(
                        title: Text(
                          LocalizationHelper.localizeSubcategory(loc, cat.name),
                          style: const TextStyle(fontSize: 12),
                        ),
                        selected: isSelected,
                        selectedTileColor: Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.1),
                        onTap: () {
                          setState(() {
                            selectedSubcategory = cat.name;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

                const VerticalDivider(width: 1),

                // ➡️ Right: Book Results
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🧭 Filters Summary
                        Text(
                          loc.filters,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('${loc.genre}: ${selectedGenres.isNotEmpty ? selectedGenres.map((g) => LocalizationHelper.localizeGenre(loc, g)).join(', ') : loc.none}'),
                        Text('${loc.subcategory}: ${selectedSubcategory != null ? LocalizationHelper.localizeSubcategory(loc, selectedSubcategory!) : loc.none}'),
                        const SizedBox(height: 16),

                        // 📚 Book Grid
                        Expanded(
                          child: filtered.isEmpty
                              ? Center(child: Text(loc.searchBoxText))
                              : BookGridView(
                            books: filtered,
                            colCount: 2,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (book.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.network(book.imageUrl!, fit: BoxFit.cover),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
