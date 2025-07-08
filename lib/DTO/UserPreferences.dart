class UserPreferences {
  bool? isDarkMode; // nullable to support system default
  bool sfxEnabled;
  bool autoReadEnabled; // <-- newly added
  String ageGroup;
  String language;
  bool isConnected;

  UserPreferences({
    this.isDarkMode,
    required this.sfxEnabled,
    required this.autoReadEnabled, // <-- required
    required this.ageGroup,
    required this.language,
    this.isConnected = false,
  });

  /// Default values
  factory UserPreferences.defaultValues() {
    return UserPreferences(
      isDarkMode: null,
      sfxEnabled: true,
      autoReadEnabled: false, // <-- default false
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
      autoReadEnabled: json['autoReadEnabled'] ?? false, // <-- load from json
      ageGroup: json['ageGroup'] ?? '18_30',
      language: json['language'] ?? 'bn',
      isConnected: json['isConnected'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    if (isDarkMode != null) 'isDarkMode': isDarkMode,
    'sfxEnabled': sfxEnabled,
    'autoReadEnabled': autoReadEnabled, // <-- added to json
    'ageGroup': ageGroup,
    'language': language,
    'isConnected': isConnected,
  };

  /// Copy with
  UserPreferences copyWith({
    bool? isDarkMode,
    bool? sfxEnabled,
    bool? autoReadEnabled,
    String? ageGroup,
    String? language,
    bool? isConnected,
  }) {
    return UserPreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      autoReadEnabled: autoReadEnabled ?? this.autoReadEnabled,
      ageGroup: ageGroup ?? this.ageGroup,
      language: language ?? this.language,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
