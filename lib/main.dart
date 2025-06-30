import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golpo/pages/BuyCoinsPage.dart';
import 'package:golpo/service/UserService.dart';
import 'package:golpo/widgets/splash_screen.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UserService.getUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Optionally log or handle error
    }
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _user == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    }

    final prefs = _user!.preferences;
    final localeParts = prefs.language.split('_');
    final locale = localeParts.length == 1
        ? Locale(localeParts[0])
        : Locale(localeParts[0], localeParts[1]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Story App',
      themeMode: prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
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
          user: _user!,
          onThemeChange: _updateTheme,
          onLocaleChange: _updateLocale,
        ),
        '/buy': (context) => const BuyCoinsPage(),
      },
    );
  }
}
