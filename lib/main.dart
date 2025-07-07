import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Add this
import 'package:golpo/pages/BuyCoinsPage.dart';
import 'package:golpo/pages/CacheManagerPage.dart';

import 'DTO/User.dart';
import 'home/story_page.dart';
import 'l10n/app_localizations.dart';
import 'service/UserService.dart';
import 'home/age_input_page.dart';
import 'pages/settings_page.dart';
import 'utils/initial_loader_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;
  Brightness? _systemBrightness;

  @override
  void initState() {
    super.initState();
    _loadUser();

    _systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      final newBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (_systemBrightness != newBrightness) {
        _systemBrightness = newBrightness;

        if (_user?.preferences.isDarkMode == null) {
          setState(() {});
        }
      }
    };
  }

  Future<void> _loadUser() async {
    final user = await UserService.getUser();
    setState(() => _user = user);
  }

  void _updateTheme(bool? isDark) async {
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
    if (_user == null) {
      return const Material(child: Center(child: CircularProgressIndicator()));
    }

    final prefs = _user!.preferences;
    final isDarkMode = prefs.isDarkMode ?? (_systemBrightness == Brightness.dark);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
          systemNavigationBarIconBrightness:
          isDarkMode ? Brightness.light : Brightness.dark,
        ),
      );
    });

    final localeParts = prefs.language.split('_');
    final locale = localeParts.length == 1
        ? Locale(localeParts[0])
        : Locale(localeParts[0], localeParts[1]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Story App',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB7416E),
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A0B10),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8E244F),
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
        '/caches': (context) => const CacheManagerPage(),
      },
    );
  }
}
