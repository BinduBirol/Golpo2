import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../DTO/Book.dart';
import '../book/BookViewingList.dart';
import '../l10n/app_localizations.dart';
import '../notifications/NotificationPage.dart';
import '../book/BookDetailPage.dart';

class StoryAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Book> books;

  StoryAppBar({
    Key? key,
    required this.title,
    required this.scaffoldKey,
    required this.books,
  }) : super(key: key);

  @override
  _StoryAppBarState createState() => _StoryAppBarState();

  // Set a large enough preferredSize to handle both search bar and suggestions
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 140);
}

class _StoryAppBarState extends State<StoryAppBar> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = [];
      } else {
        _filteredBooks = widget.books
            .where((book) => book.title.toLowerCase().contains(query))
            .toList();
      }
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
    final hasQuery = _searchController.text.isNotEmpty;

    return Material(
      color: appBarTheme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: appBarTheme.backgroundColor,
            foregroundColor: appBarTheme.foregroundColor,
            leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.bars, color: appBarTheme.foregroundColor),
              onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchBoxText,
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: FaIcon(FontAwesomeIcons.bell, color: appBarTheme.foregroundColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationPage()),
                  );
                },
              ),
            ],
          ),

          // Suggestions Box
          if (hasQuery && _filteredBooks.isNotEmpty)
            Container(
              height: 100, // Adjust to fit nicely
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                itemCount: _filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = _filteredBooks[index];
                  return ListTile(
                    title: Text(
                      book.title,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _searchController.clear();
                      setState(() => _filteredBooks.clear());
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
