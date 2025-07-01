import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/story_page.dart';
import '../service/data_loader.dart';
import '../user/age_input_page.dart';
import '../utils/background_audio.dart';
import '../l10n/app_localizations.dart';

enum LoaderState { splash, loading, ready }

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
  LoaderState _state = LoaderState.splash;
  double _progress = 0.0;
  String _loadingStage = "";

  late bool isDarkMode;
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    isDarkMode = false;
    _locale = const Locale('en');

    // Start splash → then auto-load
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _state = LoaderState.loading);
      _loadEverything();
    });
  }


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
      _state = LoaderState.ready;
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
    if (_state == LoaderState.ready) {
      _startApp();
    }
  }

  Widget _buildLottieAnimation(String assetPath, String keyLabel,
      {double width = 300, double height = 300}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Lottie.asset(
        assetPath,
        key: ValueKey(keyLabel),
        width: width,
        height: height,
        repeat: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    Widget content;

    switch (_state) {
      case LoaderState.splash:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLottieAnimation('assets/animations/reading_girl.json', 'splash'),
            const SizedBox(height: 20),
            Text(
              local.tapToValidateData,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
        break;

      case LoaderState.loading:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLottieAnimation(
              'assets/animations/medicating_girl.json',
              'loading',
              width: 260,
              height: 260,
            ),
            const SizedBox(height: 16),
            Text(
              _loadingStage,
              style: TextStyle(fontSize: 16, color: theme.colorScheme.primary),
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
        );
        break;

      case LoaderState.ready:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLottieAnimation('assets/animations/ok_girl.json', 'ready'),
            const SizedBox(height: 20),
            Text(
              local.tapToContinue,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
        break;
    }

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Stack(
          children: [
            Center(child: content),
            if (_state == LoaderState.loading)
              Positioned(
                bottom: 90,
                left: 40,
                right: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: _progress),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(
                        value: value,
                        minHeight: 10,
                        valueColor:
                        AlwaysStoppedAnimation(theme.colorScheme.primary),
                        backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
