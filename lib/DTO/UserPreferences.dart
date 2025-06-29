class UserPreferences {
  bool isDarkMode;
  bool musicEnabled;
  bool sfxEnabled;
  double musicVolume;
  String ageGroup;
  String language;

  UserPreferences({
    required this.isDarkMode,
    required this.musicEnabled,
    required this.sfxEnabled,
    required this.musicVolume,
    required this.ageGroup,
    required this.language,
  });

  factory UserPreferences.defaultValues() {
    return UserPreferences(
      isDarkMode: true,
      musicEnabled: true,
      sfxEnabled: true,
      musicVolume: 0.6,
      ageGroup: '18_30',
      language: 'bn',
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isDarkMode: json['isDarkMode'] ?? false,
      musicEnabled: json['musicEnabled'] ?? true,
      sfxEnabled: json['sfxEnabled'] ?? true,
      musicVolume: (json['musicVolume'] ?? 1.0).toDouble(),
      ageGroup: json['ageGroup'] ?? '18_30',
      language: json['language'] ?? 'bn',
    );
  }

  Map<String, dynamic> toJson() => {
    'isDarkMode': isDarkMode,
    'musicEnabled': musicEnabled,
    'sfxEnabled': sfxEnabled,
    'musicVolume': musicVolume,
    'ageGroup': ageGroup,
    'language': language,
  };
}
