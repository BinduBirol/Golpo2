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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 120); // accommodate search and suggestions
}

class _StoryAppBarState extends State<StoryAppBar> {
  String _languageLabel = '';
  final TextEditingController _searchController = TextEditingController();
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
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

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language') ?? 'bn';
    setState(() {
      _languageLabel = langCode == 'bn' ? '' : 'English';
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

    final double appBarHeight = hasQuery
        ? kToolbarHeight + 120
        : kToolbarHeight;

    return SizedBox(
      height: appBarHeight,
      child: Column(
        children: [
          AppBar(
            backgroundColor: appBarTheme.backgroundColor,
            foregroundColor: appBarTheme.foregroundColor,
            leading: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.bars,
                color: appBarTheme.foregroundColor,
              ),
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
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
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
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  color: appBarTheme.foregroundColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationPage()),
                  );
                },
              ),
            ],
          ),

          // Only show suggestions if there's a search query AND filtered books are available
          if (hasQuery && _filteredBooks.isNotEmpty)
            Flexible(
              child: BookViewingList(
                books: _filteredBooks,
                onBookTap: (book) {
                  _searchController.clear();
                  setState(() => _filteredBooks.clear());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailPage(book: book),
                    ),
                  );
                },
              ),
            )
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }
}
