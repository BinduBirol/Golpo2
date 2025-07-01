import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../DTO/Book.dart';
import '../../book/SearchPage.dart';
import '../../notifications/NotificationPage.dart';

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
    final Color topGradientColor =
        appBarTheme.backgroundColor ?? const Color(0xFFB71C1C);

    return Stack(
      children: [
        // Gradient background behind the AppBar
        Container(
          height: preferredSize.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                topGradientColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
        ),

        // Transparent AppBar layered on top
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: appBarTheme.foregroundColor,

          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.bars),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            color: appBarTheme.backgroundColor,
            tooltip: 'Menu',
          ),

          title: Text(
            title,
            style: TextStyle(
              color: appBarTheme.backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SearchPage(allBooks: books)),
                );
              },
              color: appBarTheme.backgroundColor,
              tooltip: 'Search',
            ),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.bell),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationPage()),
                );
              },
              color: appBarTheme.backgroundColor,
              tooltip: 'Notifications',
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.gear),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              color: appBarTheme.backgroundColor,
              tooltip: 'Search',
            ),
          ],
        ),
      ],
    );
  }
}
