import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class BackgroundAudio {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isInitialized = false;

  /// Get correct default asset path based on platform
  static String get _backgroundMusicPath =>
      kIsWeb ? 'music/bg/szbg1.ogg' : 'music/bg/szbg1.mp3';

  /// Initialize and play background music if enabled in settings
  static Future<void> initAndPlayIfEnabled() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final isMusicEnabled = prefs.getBool('music') ?? true;

    _player.setReleaseMode(ReleaseMode.loop);
    //_player.setVolume(volume);

    if (isMusicEnabled) {
      await _player.play(AssetSource(_backgroundMusicPath));
    }

    _isInitialized = true;
  }

  /// Toggle music on/off
  static Future<void> toggleMusic(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music', enabled);

    if (enabled) {
      await _player.play(AssetSource(_backgroundMusicPath));
    } else {
      await _player.pause();
    }
  }

  /// Set volume dynamically (0.0 to 1.0)
  static Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('music_volume', volume);
  }

  /// Play book music by bookId
  /// Loops the music until stopped or changed
  static Future<void> playBookMusic(String bookId) async {
    // Map book IDs to asset paths; customize as needed
    const bookMusicMap = {
      'book1': 'music/bg/book1_theme.ogg',
      'book2': 'music/bg/book2_theme.ogg',
      'szbg1': 'music/bg/szbg1.ogg',
      // Add more mappings here
    };

    final assetPath = bookMusicMap[bookId];
    if (assetPath == null) {
      print('BackgroundAudio: No music asset found for bookId: $bookId');
      return;
    }

    // Stop any current playback before playing new track
    await _player.stop();

    _player.setReleaseMode(ReleaseMode.loop);

    final prefs = await SharedPreferences.getInstance();
    final volume = prefs.getDouble('music_volume') ?? 1.0;
    _player.setVolume(volume);

    await _player.play(AssetSource(assetPath));
  }
}
