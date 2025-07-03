import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/DTO/User.dart';
import 'package:golpo/book/BookDetailPage.dart';
import 'package:golpo/home/drawer_header_widget.dart';
import 'package:golpo/service/BookService.dart';
import 'package:golpo/service/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DTO/Book.dart';
import '../book/book_grid_view.dart';
import '../l10n/app_localizations.dart';
import '../pages/profile_page.dart';
import '../pages/settings_page.dart';
import '../widgets/CustomListTile.dart';
import '../widgets/MyLoadingIndicator.dart';
import '../widgets/app_bar/StoryAppBar.dart';
import 'category_page.dart';

class StoryPage extends StatefulWidget {
  final Function(bool) onThemeChange;
  final Function(String) onLocaleChange; // ✅ Add this line

  const StoryPage({
    required this.onThemeChange,
    required this.onLocaleChange, // ✅ Add this line
  });

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Book> _books = [];
  bool _isLoading = true;
  String? _error;

  late User _user;

  @override
  void initState() {
    super.initState();
    _loadBooks(); // <-- Load books here
    _loadUser();
  }

  Future<void> _resetAge(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('age_group');
    Navigator.pushReplacementNamed(context, '/age');
  }

  Future<void> _loadBooks() async {
    try {

      final books = await BookService.fetchBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = true;
      });
    }
  }

  Future<void> _loadUser() async {
    try {

      final user = await UserService.getUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    if (_isLoading) {
      return Scaffold(body: Center(child: MyLoadingIndicator(message: "Loading books..")));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error loading books: $_error')),
      );
    }

    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key here
      appBar: StoryAppBar(
        title: AppLocalizations.of(context)!.appTitle,
        scaffoldKey: _scaffoldKey,
        books: _books, // pass loaded list here
      ),
      drawer: Drawer(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeaderWidget(),
            CustomListTile(
              iconData: Icons.library_books,
              title: AppLocalizations.of(context)!.library,
              onTap: () => _navigateTo(context, CategoryPage()),
            ),

            CustomListTile(
              iconData: Icons.person_outline,

              title: AppLocalizations.of(context)!.profile,
              onTap: () => _navigateTo(context, ProfilePage(
                user: _user,
              )),
            ),
            CustomListTile(
              iconData: Icons.settings,
              title: AppLocalizations.of(context)!.settings,
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),

            CustomListTile(
              iconData: FontAwesomeIcons.coins,
              title: AppLocalizations.of(context)!.coinStore,
              onTap: () => Navigator.pushNamed(context, '/buy'),
            ),
            CustomListTile(
              iconData: FontAwesomeIcons.hardDrive,
              title: AppLocalizations.of(context)!.offlineData,
              onTap: () => Navigator.pushNamed(context, '/caches'),
            ),
          ],
        ),
      ),
      body: BookGridView(
        books: _books,
        onBookTap: (Book book) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
          );
        },
      ),
    );
  }
}
