import 'package:flutter/material.dart';

import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';
import '../l10n/app_localizations.dart';
import '../service/UserService.dart';
import '../utils/background_audio.dart';
import '../widgets/app_bar/my_app_bar.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool? isDarkMode) onThemeChange;
  final Function(String) onLocaleChange;

  const SettingsPage({
    super.key,
    required this.onThemeChange,
    required this.onLocaleChange,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserPreferences? prefs;
  User? user;
  bool isLoading = true;

  final languageOptions = {'en': 'English', 'bn': 'বাংলা'};

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    user = await UserService.getUser();
    prefs = user!.preferences;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    if (prefs == null) return;
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
    if (isLoading || prefs == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  value: _themeValueFromPrefs(prefs!.isDarkMode),
                  items: const {
                    'system': 'System',
                    'light': 'Light',
                    'dark': 'Dark',
                  },
                  onChanged: (val) async {
                    final newPref = _prefsValueFromTheme(val);
                    setState(() => prefs!.isDarkMode = newPref);
                    await _savePreferences();
                    widget.onThemeChange(newPref);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: AppLocalizations.of(context)!.language,
                  value: prefs!.language,
                  items: languageOptions,
                  onChanged: (val) async {
                    if (val != null) {
                      setState(() => prefs!.language = val);
                      await _savePreferences();
                      widget.onLocaleChange(val);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Sound Effects switch
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(AppLocalizations.of(context)!.soundEffects),
            value: prefs!.sfxEnabled,
            onChanged: (val) async {
              setState(() => prefs!.sfxEnabled = val);
              await _savePreferences();
            },
            secondary: const Icon(Icons.surround_sound),
          ),

          const SizedBox(height: 16),

          /// Sound Effects switch
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Auto reading"),
            value: prefs!.autoReadEnabled,
            onChanged: (val) async {
              setState(() => prefs!.autoReadEnabled = val);
              await _savePreferences();
            },
            secondary: const Icon(Icons.play_circle),
          ),

          const Divider(height: 32),

          /// Age Group dropdown
          _buildDropdownField(
            label: AppLocalizations.of(context)!.ageGroup,
            value: prefs!.ageGroup,
            items: ageOptions,
            onChanged: (val) async {
              if (val != null) {
                setState(() => prefs!.ageGroup = val);
                await _savePreferences();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
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
