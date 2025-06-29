import 'package:flutter/material.dart';
import 'package:golpo/pages/BuyCoinsPage.dart';
import 'package:golpo/service/UserService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'DTO/User.dart'; // Your User & UserPreferences class
import 'utils/initial_loader_page.dart';
import 'user/age_input_page.dart';
import 'home/story_page.dart';
import 'user/settings_page.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final user = await UserService.getUser(); // ✅ Load user with preferences

  runApp(MyApp(user: user));
}

class MyApp extends StatefulWidget {
  final User user;

  const MyApp({super.key, required this.user});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _updateTheme(bool isDark) async {
    final updatedPrefs = _user.preferences..isDarkMode = isDark;
    final updatedUser = _user.copyWith(preferences: updatedPrefs);

    setState(() => _user = updatedUser);
    await UserService.setUser(updatedUser);
  }

  void _updateLocale(String langCode) async {
    final updatedPrefs = _user.preferences..language = langCode;
    final updatedUser = _user.copyWith(preferences: updatedPrefs);

    setState(() => _user = updatedUser);
    await UserService.setUser(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = _user.preferences;
    final localeParts = prefs.language.split('_');
    final locale = localeParts.length == 1
        ? Locale(localeParts[0])
        : Locale(localeParts[0], localeParts[1]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Story App',
      themeMode: prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'open-sans',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'open-sans',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.black,
        ),
      ),
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: InitialLoaderPage(
        onThemeChange: _updateTheme,
        onLocaleChange: _updateLocale,
      ),
      routes: {
        '/age': (context) => AgeInputPage(),
        '/story': (context) => StoryPage(
          onThemeChange: _updateTheme,
          onLocaleChange: _updateLocale,
        ),
        '/settings': (context) => SettingsPage(
          user: _user, // ✅ Now this is defined
          onThemeChange: _updateTheme,
          onLocaleChange: _updateLocale,
        ),
        '/buy': (context) => BuyCoinsPage(),
      },
    );
  }
}
