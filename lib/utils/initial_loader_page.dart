import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/story_page.dart';
import '../user/age_input_page.dart';
import '../utils/background_audio.dart';
import '../l10n/app_localizations.dart';



class InitialLoaderPage extends StatefulWidget {
  final Function(bool) onThemeChange;
  final Function(String) onLocaleChange;

  const InitialLoaderPage({
    super.key,
    required this.onThemeChange,
    required this.onLocaleChange,
  });

  @override
  State<InitialLoaderPage> createState() => _InitialLoaderPageState();
}

class _InitialLoaderPageState extends State<InitialLoaderPage> {
  bool _hasTapped = false;

  late bool isDarkMode;
  Locale _locale = const Locale('en');

  void _updateTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
  }

  void _updateLocale(String langCode) {
    setState(() {
      _locale = Locale(langCode);
    });
  }

  Future<void> _startApp() async {
    try {
      await BackgroundAudio.initAndPlayIfEnabled();
    } catch (e) {
      print('Audio error: $e');
    }

    final prefs = await SharedPreferences.getInstance();
    final hasAgeGroup = prefs.containsKey('age_group');

    if (hasAgeGroup) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StoryPage(
            onThemeChange: _updateTheme,
            onLocaleChange: _updateLocale, // ✅ Must be passed here
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AgeInputPage(),
        ),
      );
    }
  }

  void _onTap() {
    if (!_hasTapped) {
      setState(() => _hasTapped = true);
      _startApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _hasTapped ? 0.0 : 1.0,
            child: Text(
              local.tapToContinue,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary, // dynamic pink accent
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
