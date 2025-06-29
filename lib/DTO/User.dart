import 'UserPreferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  final int walletCoin;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.walletCoin,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    walletCoin: json['walletCoin'] ?? 0,
    preferences: json['preferences'] != null
        ? UserPreferences.fromJson(json['preferences'])
        : UserPreferences.defaultValues(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'walletCoin': walletCoin,
    'preferences': preferences.toJson(),
  };

  User copyWith({
    String? id,
    String? name,
    String? email,
    int? walletCoin,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      walletCoin: walletCoin ?? this.walletCoin,
      preferences: preferences ?? this.preferences,
    );
  }
}
