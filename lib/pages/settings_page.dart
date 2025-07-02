import 'package:flutter/material.dart';

import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';
import '../l10n/app_localizations.dart';
import '../service/UserService.dart';
import '../utils/background_audio.dart';
import '../widgets/app_bar/my_app_bar.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  final Function(bool? isDarkMode) onThemeChange;
  final Function(String) onLocaleChange;

  const SettingsPage({
    super.key,
    required this.user,
    required this.onThemeChange,
    required this.onLocaleChange,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserPreferences prefs;

  final languageOptions = {'en': 'English', 'bn': 'বাংলা'};

  @override
  void initState() {
    super.initState();
    prefs = widget.user.preferences;
    BackgroundAudio.setVolume(prefs.musicVolume);
  }

  Future<void> _savePreferences() async {
    final latestUser = await UserService.getUser();
    final updatedUser = latestUser.copyWith(preferences: prefs);
    await UserService.setUser(updatedUser);
  }

  String _themeValueFromPrefs(bool? isDarkMode) {
    if (isDarkMode == null) return 'system';
    return isDarkMode ? 'dark' : 'light';
  }

  bool? _prefsValueFromTheme(String? value) {
    switch (value) {
      case 'dark':
        return true;
      case 'light':
        return false;
      case 'system':
        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ageOptions = {
      'under_18': AppLocalizations.of(context)!.under18,
      '18_30': AppLocalizations.of(context)!.ageGroup18to30,
      'over_30': AppLocalizations.of(context)!.over30,
    };

    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context)!.settings),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          /// Theme + Language
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: AppLocalizations.of(context)!.theme,
                  value: _themeValueFromPrefs(prefs.isDarkMode),
                  items: const {
                    'system': 'System',
                    'light': 'Light',
                    'dark': 'Dark',
                  },
                  onChanged: (val) {
                    final newPref = _prefsValueFromTheme(val);
                    setState(() => prefs.isDarkMode = newPref);
                    _savePreferences();
                    widget.onThemeChange(newPref);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: AppLocalizations.of(context)!.language,
                  value: prefs.language,
                  items: languageOptions,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => prefs.language = val);
                      _savePreferences();
                      widget.onLocaleChange(val);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Age Group (single row)
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(context)!.soundEffects),
                  value: prefs.sfxEnabled,
                  onChanged: (val) {
                    setState(() => prefs.sfxEnabled = val);
                    _savePreferences();
                  },
                  secondary: const Icon(Icons.surround_sound),
                ),
              ),
            ],
          ),

          const Divider(height: 32),

          /// Audio Settings (switches in a row)
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: AppLocalizations.of(context)!.ageGroup,
                  value: prefs.ageGroup,
                  items: ageOptions,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => prefs.ageGroup = val);
                      _savePreferences();
                    }
                  },
                ),
              ),

              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(context)!.audio),
                  value: prefs.musicEnabled,
                  onChanged: (val) {
                    setState(() => prefs.musicEnabled = val);
                    _savePreferences();
                    BackgroundAudio.toggleMusic(val);
                  },
                  secondary: const Icon(Icons.music_note),
                ),
              ),

              //const SizedBox(width: 16),
            ],
          ),

          const SizedBox(height: 8),

          /// Music Volume
          Text(
            AppLocalizations.of(context)!.musicVolume,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Icon(prefs.musicVolume == 0 ? Icons.volume_off : Icons.volume_up),
              const SizedBox(width: 4),
              Expanded(
                child: Slider(
                  value: prefs.musicVolume,
                  onChanged: prefs.musicEnabled
                      ? (val) {
                          setState(() => prefs.musicVolume = val);
                          _savePreferences();
                          BackgroundAudio.setVolume(val);
                        }
                      : null,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: "${(prefs.musicVolume * 100).round()}%",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
