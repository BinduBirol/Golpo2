class UserPreferences {
  bool? isDarkMode; // nullable to support system default
  bool sfxEnabled;
  String ageGroup;
  String language;
  bool isConnected; // <-- newly added

  UserPreferences({
    this.isDarkMode,
    required this.sfxEnabled,
    required this.ageGroup,
    required this.language,
    this.isConnected = false, // default value
  });

  /// Default values with isDarkMode set to null (system default)
  factory UserPreferences.defaultValues() {
    return UserPreferences(
      isDarkMode: null,
      // Follow system theme
      sfxEnabled: true,
      ageGroup: '18_30',
      language: 'bn',
      isConnected: false,
    );
  }

  /// Load from JSON (null-safe for isDarkMode)
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isDarkMode: json.containsKey('isDarkMode') ? json['isDarkMode'] : null,

      sfxEnabled: json['sfxEnabled'] ?? true,

      ageGroup: json['ageGroup'] ?? '18_30',
      language: json['language'] ?? 'bn',
      isConnected: json['isConnected'] ?? false,
    );
  }

  /// Convert to JSON (skips isDarkMode if null)
  Map<String, dynamic> toJson() => {
    if (isDarkMode != null) 'isDarkMode': isDarkMode,

    'sfxEnabled': sfxEnabled,
    'ageGroup': ageGroup,
    'language': language,
    'isConnected': isConnected,
  };

  UserPreferences copyWith({
    bool? isDarkMode,
    bool? sfxEnabled,
    String? ageGroup,
    String? language,
    bool? isConnected,
  }) {
    return UserPreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,

      sfxEnabled: sfxEnabled ?? this.sfxEnabled,

      ageGroup: ageGroup ?? this.ageGroup,
      language: language ?? this.language,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
