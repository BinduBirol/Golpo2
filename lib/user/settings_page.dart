import 'package:flutter/material.dart';
import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';
import '../service/UserService.dart';
import '../utils/background_audio.dart';
import '../widgets/app_bar/my_app_bar.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  final Function(bool isDarkMode) onThemeChange;
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
    final latestUser = await UserService.getUser(); // ✅ get up-to-date user
    final updatedUser = latestUser.copyWith(preferences: prefs); // ✅ update only preferences
    await UserService.setUser(updatedUser); // ✅ save updated user
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
            value: prefs.isDarkMode,
            onChanged: (val) {
              setState(() => prefs.isDarkMode = val);
              _savePreferences();
              widget.onThemeChange(val);
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(height: 32),

          _buildSectionTitle(AppLocalizations.of(context)!.audio),
          SwitchListTile(
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
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(AppLocalizations.of(context)!.soundEffects),
            value: prefs.sfxEnabled,
            onChanged: (val) {
              setState(() => prefs.sfxEnabled = val);
              _savePreferences();
            },
            secondary: const Icon(Icons.surround_sound),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.musicVolume,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Icon(prefs.musicVolume == 0 ? Icons.volume_off : Icons.volume_up),
              const SizedBox(width: 8),
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
          const Divider(height: 32),

          _buildSectionTitle(AppLocalizations.of(context)!.preferences),
          const SizedBox(height: 4),
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
