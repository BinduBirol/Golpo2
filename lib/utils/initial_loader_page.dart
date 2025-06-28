import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/story_page.dart';
import '../service/BookService.dart';
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
  bool _loadingDone = false;
  double _progress = 0.0; // Progress from 0.0 to 1.0

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

  Future<void> _loadData() async {
    try {
      await BackgroundAudio.initAndPlayIfEnabled();
    } catch (e) {
      print('Audio error: $e');
    }

    // Simulate loading books with progress update
    final totalSteps = 100;
    for (int i = 1; i <= totalSteps; i++) {
      await Future.delayed(
        const Duration(milliseconds: 30),
      ); // simulate loading delay
      setState(() {
        _progress = i / totalSteps;
      });
    }

    setState(() {
      _loadingDone = true; // Loading finished
    });
  }

  Future<void> _startApp() async {
    final prefs = await SharedPreferences.getInstance();
    final hasAgeGroup = prefs.containsKey('age_group');

    if (hasAgeGroup) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              StoryPage(
                onThemeChange: _updateTheme,
                onLocaleChange: _updateLocale,
              ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AgeInputPage()),
      );
    }
  }

  void _onTap() {
    if (!_hasTapped && _loadingDone) {
      setState(() => _hasTapped = true);
      _startApp();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Start loading immediately on page load
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
          child: !_loadingDone
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                value: _progress,
                strokeWidth: 6,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.loadingData} ${(_progress *
                    100).toInt()}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          )
              : AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0,
            child: Text(
              local.tapToContinue,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
