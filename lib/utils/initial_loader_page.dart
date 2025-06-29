import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/story_page.dart';
import '../service/data_loader.dart';
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
  bool _hasTappedToLoad = false;
  bool _loadingDone = false;
  double _progress = 0.0;
  String _loadingStage = "";

  late bool isDarkMode;
  Locale _locale = const Locale('en');

  void _updateTheme(bool isDark) => setState(() => isDarkMode = isDark);
  void _updateLocale(String langCode) => setState(() => _locale = Locale(langCode));

  Future<void> _loadEverything() async {
    try {
      await BackgroundAudio.initAndPlayIfEnabled();
    } catch (e) {
      print('Audio error: $e');
    }

    await DataLoader.loadDataWithProgress((progress, stage) {
      setState(() {
        _progress = progress;
        _loadingStage = stage;
      });
    });

    setState(() {
      _loadingDone = true;
    });
  }

  Future<void> _startApp() async {
    final prefs = await SharedPreferences.getInstance();
    final hasAgeGroup = prefs.containsKey('age_group');

    if (hasAgeGroup) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StoryPage(
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
    if (_loadingDone) {
      _startApp();
    } else if (!_hasTappedToLoad) {
      setState(() => _hasTappedToLoad = true);
      _loadEverything();
    }
  }

  @override
  void initState() {
    super.initState();
    // Don't load on init — wait for tap
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Stack(
          children: [
            // Background SVG
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/img/loader_background.svg',
                fit: BoxFit.cover,
              ),
            ),

            // Foreground content
            Center(
              child: !_hasTappedToLoad
                  ? Text(
                local.tapToValidateData,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              )
                  : !_loadingDone
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
                    _loadingStage,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${local.loadingData} ${(100 * _progress).toInt()}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              )
                  : Text(
                local.tapToContinue,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),

      ),
    );
  }
}
