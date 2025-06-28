import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoryAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey; // to open drawer

  StoryAppBar({Key? key, required this.title, required this.scaffoldKey})
      : super(key: key);

  @override
  _StoryAppBarState createState() => _StoryAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _StoryAppBarState extends State<StoryAppBar> {
  String _languageLabel = '';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language') ?? 'en';

    setState(() {
      _languageLabel = langCode == 'bn' ? /* 'বাংলা' */ '' : 'English';
    });
  }

  void _goToSettings() {
    Navigator.pushNamed(context, '/settings'); // Make sure your route exists
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      backgroundColor: appBarTheme.backgroundColor,
      foregroundColor: appBarTheme.foregroundColor,
      title: Row(
        children: [
          Text(widget.title),
          /* Uncomment to show language text:
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: appBarTheme.foregroundColor?.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _languageLabel,
              style: TextStyle(
                color: appBarTheme.foregroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),*/
        ],
      ),
      leading: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.bars, // hamburger menu icon
          color: appBarTheme.foregroundColor,
        ),
        onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.gear, // settings icon (use 'gear' instead of deprecated 'cog')
            color: appBarTheme.foregroundColor,
          ),
          onPressed: _goToSettings,
        ),
      ],
    );
  }
}
