import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/home/drawer_header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../user/profile_page.dart';
import '../user/settings_page.dart';
import '../widgets/CustomListTile.dart';
import '../widgets/StoryAppBar.dart';
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

  Future<void> _resetAge(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('age_group');
    Navigator.pushReplacementNamed(context, '/age');
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;


    return Scaffold(
      key: _scaffoldKey, // Assign the scaffold key here
      appBar: StoryAppBar(title: AppLocalizations.of(context)!.appTitle, scaffoldKey: _scaffoldKey),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeaderWidget(),
            CustomListTile(
              iconData: FontAwesomeIcons.layerGroup,
              title: AppLocalizations.of(context)!.library,
              onTap: () => _navigateTo(context, CategoryPage()),
            ),

            CustomListTile(
              iconData: FontAwesomeIcons.user,

              title: AppLocalizations.of(context)!.profile,
              onTap: () => _navigateTo(context, ProfilePage()),
            ),
            CustomListTile(
              iconData: FontAwesomeIcons.gear,
              title: AppLocalizations.of(context)!.settings,

              onTap: () => _navigateTo(
                context,
                SettingsPage(
                  onThemeChange: widget.onThemeChange,
                  onLocaleChange: widget.onLocaleChange,
                ),
              ),

            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.storyIntro,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),

    );
  }
}
