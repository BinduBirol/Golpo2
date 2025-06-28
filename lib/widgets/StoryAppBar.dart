import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../DTO/Book.dart';
import '../book/SearchPage.dart';
import '../notifications/NotificationPage.dart';

class StoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Book> books;

  const StoryAppBar({
    Key? key,
    required this.title,
    required this.scaffoldKey,
    required this.books,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      backgroundColor: appBarTheme.backgroundColor,
      foregroundColor: appBarTheme.foregroundColor,
      leading: IconButton(
        icon: FaIcon(FontAwesomeIcons.bars, color: appBarTheme.foregroundColor),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchPage(allBooks: books),
              ),
            );
          },        ),
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
    );
  }
}
