import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../DTO/Book.dart';
import '../../book/SearchPage.dart';
import '../../notifications/NotificationPage.dart';
import '../button/button_decorators.dart';

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

    // Use a fallback color in case appBarTheme.backgroundColor is null
    final Color topGradientColor = appBarTheme.backgroundColor ?? const Color(0xFFB71C1C);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    topGradientColor, // dark maroon (or fallback) at top
                    Theme.of(context).scaffoldBackgroundColor, // lighter at bottom
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      foregroundColor: appBarTheme.foregroundColor,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: ButtonDecorators.circularIconButton(
          icon: FontAwesomeIcons.bars,
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          iconColor: appBarTheme.foregroundColor,
          backgroundColor: appBarTheme.backgroundColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: appBarTheme.backgroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        ButtonDecorators.circularIconButton(
          icon: Icons.search,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchPage(allBooks: books)),
            );
          },
          iconColor: appBarTheme.foregroundColor,
          backgroundColor: appBarTheme.backgroundColor,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: ButtonDecorators.circularIconButton(
            icon: FontAwesomeIcons.bell,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationPage()),
              );
            },
            iconColor: appBarTheme.foregroundColor,
            backgroundColor: appBarTheme.backgroundColor,
          ),
        ),
      ],
    );
  }
}
