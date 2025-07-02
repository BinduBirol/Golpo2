import 'UserPreferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  final int walletCoin;
  final bool isVerified;
  final int followers;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.walletCoin,
    required this.isVerified,
    required this.followers,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    walletCoin: json['walletCoin'] ?? 0,
    isVerified: json['isVerified'] ?? false,
    followers: json['followers'] ?? 0,
    preferences: json['preferences'] != null
        ? UserPreferences.fromJson(json['preferences'])
        : UserPreferences.defaultValues(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'walletCoin': walletCoin,
    'isVerified': isVerified,
    'followers': followers,
    'preferences': preferences.toJson(),
  };

  User copyWith({
    String? id,
    String? name,
    String? email,
    int? walletCoin,
    bool? isVerified,
    int? followers,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      walletCoin: walletCoin ?? this.walletCoin,
      isVerified: isVerified ?? this.isVerified,
      followers: followers ?? this.followers,
      preferences: preferences ?? this.preferences,
    );
  }
}
