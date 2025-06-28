import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundAudio {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isInitialized = false;

  /// Initialize and play background music if music is enabled in settings
  static Future<void> initAndPlayIfEnabled() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final isMusicEnabled = prefs.getBool('music') ?? true;
    final volume = prefs.getDouble('music_volume') ?? 1.0;

    _player.setReleaseMode(ReleaseMode.loop);
    _player.setVolume(volume);

    if (isMusicEnabled) {
      await _player.play(AssetSource('music/bg/szbg1.mp3'));
    }

    _isInitialized = true;
  }

  /// Toggle music on/off
  static Future<void> toggleMusic(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music', enabled);

    if (enabled) {
      await _player.play(AssetSource('music/bg/szbg1.mp3'));
    } else {
      await _player.pause();
    }
  }

  /// Set volume dynamically (0.0 to 1.0)
  static Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);

    // Save volume to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('music_volume', volume);
  }
}
