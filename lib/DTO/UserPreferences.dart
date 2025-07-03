class UserPreferences {
  bool? isDarkMode; // nullable to support system default
  bool musicEnabled;
  bool sfxEnabled;
  double musicVolume;
  String ageGroup;
  String language;
  bool isConnected; // <-- newly added

  UserPreferences({
    this.isDarkMode,
    required this.musicEnabled,
    required this.sfxEnabled,
    required this.musicVolume,
    required this.ageGroup,
    required this.language,
    this.isConnected = false, // default value
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
      isConnected: false,
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
      isConnected: json['isConnected'] ?? false,
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
    'isConnected': isConnected,
  };

  UserPreferences copyWith({
    bool? isDarkMode,
    bool? musicEnabled,
    bool? sfxEnabled,
    double? musicVolume,
    String? ageGroup,
    String? language,
    bool? isConnected,
  }) {
    return UserPreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      musicVolume: musicVolume ?? this.musicVolume,
      ageGroup: ageGroup ?? this.ageGroup,
      language: language ?? this.language,
      isConnected: isConnected ?? this.isConnected,
    );
  }

}
