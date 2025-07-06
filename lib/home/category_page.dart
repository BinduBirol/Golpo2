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
  Set<String> selectedSubcategories = {};

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
    final loadedBooks = await BookService.fetchBooks();

    setState(() {
      genres = loadedGenres;
      categories = loadedCategories;
      allBooks = loadedBooks;
      isLoading = false;
    });
  }

  List<Book> _filteredBooks() {
    return allBooks.where((book) {
      final matchesGenre =
          selectedGenres.isEmpty || selectedGenres.contains(book.genre);
      final matchesSub =
          selectedSubcategories.isEmpty ||
          selectedSubcategories.contains(book.category);
      return matchesGenre && matchesSub;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      selectedGenres.clear();
      selectedSubcategories.clear();
    });
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
          // 🔝 Top Filters
          // 🔝 Top Filters
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  // Adjust height as needed
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🎯 Genre Filter
                        Text(
                          loc.selectGenre,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: genres.map((genre) {
                            return FilterChip(
                              label: Text(
                                LocalizationHelper.localizeGenre(loc, genre),
                                style: const TextStyle(fontSize: 10),
                              ),
                              selected: selectedGenres.contains(genre),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onSelected: (isSelected) {
                                setState(() {
                                  isSelected
                                      ? selectedGenres.add(genre)
                                      : selectedGenres.remove(genre);
                                });
                              },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        // 🎯 Subcategory Filter
                        Text(
                          loc.selectSubcategory,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: categories.map((cat) {
                            final isSelected = selectedSubcategories.contains(
                              cat.name,
                            );
                            return FilterChip(
                              label: Text(
                                LocalizationHelper.localizeSubcategory(
                                  loc,
                                  cat.name,
                                ),
                                style: const TextStyle(fontSize: 10),
                              ),
                              selected: isSelected,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onSelected: (isSelected) {
                                setState(() {
                                  isSelected
                                      ? selectedSubcategories.add(cat.name)
                                      : selectedSubcategories.remove(cat.name);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 📋 Filter Summary + Reset
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧾 Left scrollable filter summary
                Expanded(
                  child: SizedBox(
                    height: 42, // Limit vertical height for clean layout
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${loc.genre}: ${selectedGenres.isNotEmpty ? selectedGenres.map((g) => LocalizationHelper.localizeGenre(loc, g)).join(', ') : loc.none}',
                          ),
                          Text(
                            '${loc.subcategory}: ${selectedSubcategories.isNotEmpty ? selectedSubcategories.map((s) => LocalizationHelper.localizeSubcategory(loc, s)).join(', ') : loc.none}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔄 Right reset button
                TextButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: Text("loc.reset"), // ✅ fixed localization
                ),
              ],
            ),
          ),

          // 📝 Filter Info
          const SizedBox(height: 12),

          // 📚 Book Grid
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text(loc.searchBoxText))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: BookGridView(
                      books: filtered,
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
          ),
        ],
      ),
    );
  }
}
