import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golpo/pages/BuyCoinsPage.dart';
import 'package:golpo/service/UserService.dart';

import 'DTO/User.dart';
import 'home/story_page.dart';
import 'l10n/app_localizations.dart';
import 'user/age_input_page.dart';
import 'user/settings_page.dart';
import 'utils/initial_loader_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserService.getUser();
    setState(() => _user = user);
  }

  void _updateTheme(bool isDark) async {
    final updatedPrefs = _user!.preferences..isDarkMode = isDark;
    final updatedUser = _user!.copyWith(preferences: updatedPrefs);
    setState(() => _user = updatedUser);
    await UserService.setUser(updatedUser);
  }

  void _updateLocale(String langCode) async {
    final updatedPrefs = _user!.preferences..language = langCode;
    final updatedUser = _user!.copyWith(preferences: updatedPrefs);
    setState(() => _user = updatedUser);
    await UserService.setUser(updatedUser);
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = _user?.preferences;
    final localeParts = prefs?.language.split('_') ?? ['en'];
    final locale = localeParts.length == 1
        ? Locale(localeParts[0])
        : Locale(localeParts[0], localeParts[1]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Story App',
      themeMode: prefs?.isDarkMode == true ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFF1F4),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE91E63),
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF16080F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFAD1457),
          foregroundColor: Colors.white,
        ),
      ),
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ✅ Always go to InitialLoaderPage — it will handle splash, loading, routing
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
          user: _user!,
          onThemeChange: _updateTheme,
          onLocaleChange: _updateLocale,
        ),
        '/buy': (context) => const BuyCoinsPage(),
      },
    );
  }
}
