import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../utils/background_audio.dart';
import '../widgets/my_app_bar.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool isDarkMode) onThemeChange;
  final Function(String) onLocaleChange;

  SettingsPage({required this.onThemeChange, required this.onLocaleChange});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool music = true;
  bool sfx = true;
  double musicVolume = 1.0;
  String ageGroup = '18_30';
  String language = 'bn';

  final languageOptions = {'en': 'English', 'bn': 'বাংলা'};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('dark_mode') ?? false;
      music = prefs.getBool('music') ?? true;
      sfx = prefs.getBool('sfx') ?? true;
      musicVolume = prefs.getDouble('music_volume') ?? 1.0;
      ageGroup = prefs.getString('age_group') ?? '18_30';
      language = prefs.getString('language') ?? 'bn';
    });
    BackgroundAudio.setVolume(musicVolume);
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
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
          _buildSectionTitle(AppLocalizations.of(context)!.theme),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(AppLocalizations.of(context)!.darkMode),
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
              _updateSetting('dark_mode', val);
              widget.onThemeChange(val);
            },
            secondary: Icon(Icons.dark_mode),
          ),
          Divider(height: 32),

          _buildSectionTitle(AppLocalizations.of(context)!.audio),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(AppLocalizations.of(context)!.soundEffects),
            value: sfx,
            onChanged: (val) {
              setState(() => sfx = val);
              _updateSetting('sfx', val);
            },
            secondary: Icon(Icons.surround_sound),
          ),
          SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.musicVolume,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Icon(musicVolume == 0 ? Icons.volume_off : Icons.volume_up),
              SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: musicVolume,
                  onChanged: (val) {
                    setState(() => musicVolume = val);
                    _updateSetting('music_volume', val);
                    BackgroundAudio.setVolume(val);
                  },
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: "${(musicVolume * 100).round()}%",
                ),
              ),
            ],
          ),
          Divider(height: 32),

          _buildSectionTitle(AppLocalizations.of(context)!.preferences),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: AppLocalizations.of(context)!.ageGroup,
                  value: ageGroup,
                  items: ageOptions,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => ageGroup = val);
                      _updateSetting('age_group', val);
                    }
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: AppLocalizations.of(context)!.language,
                  value: language,
                  items: languageOptions,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => language = val);
                      _updateSetting('language', val);
                      widget.onLocaleChange(val);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.entries
              .map((entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
