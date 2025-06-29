class User {
  final String id;
  final String name;
  final String email;
  final int walletCoin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.walletCoin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    walletCoin: json['walletCoin'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "walletCoin": walletCoin,
  };

  User copyWith({
    String? id,
    String? name,
    String? email,
    int? walletCoin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      walletCoin: walletCoin ?? this.walletCoin,
    );
  }
}
