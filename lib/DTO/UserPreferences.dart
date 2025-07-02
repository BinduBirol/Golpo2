class UserPreferences {
  bool? isDarkMode; // nullable to support system default
  bool musicEnabled;
  bool sfxEnabled;
  double musicVolume;
  String ageGroup;
  String language;

  UserPreferences({
    this.isDarkMode, // nullable
    required this.musicEnabled,
    required this.sfxEnabled,
    required this.musicVolume,
    required this.ageGroup,
    required this.language,
  });

  /// Default values with isDarkMode set to null (system default)
  factory UserPreferences.defaultValues() {
    return UserPreferences(
      isDarkMode: null, // Follow system theme
      musicEnabled: true,
      sfxEnabled: true,
      musicVolume: 0.6,
      ageGroup: '18_30',
      language: 'bn',
    );
  }

  /// Load from JSON (null-safe for isDarkMode)
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isDarkMode: json.containsKey('isDarkMode') ? json['isDarkMode'] : null,
      musicEnabled: json['musicEnabled'] ?? true,
      sfxEnabled: json['sfxEnabled'] ?? true,
      musicVolume: (json['musicVolume'] ?? 1.0).toDouble(),
      ageGroup: json['ageGroup'] ?? '18_30',
      language: json['language'] ?? 'bn',
    );
  }

  /// Convert to JSON (skips isDarkMode if null)
  Map<String, dynamic> toJson() => {
    if (isDarkMode != null) 'isDarkMode': isDarkMode,
    'musicEnabled': musicEnabled,
    'sfxEnabled': sfxEnabled,
    'musicVolume': musicVolume,
    'ageGroup': ageGroup,
    'language': language,
  };
}
