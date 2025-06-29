import '../DTO/User.dart';
import 'dart:math';

class UserService {
  static User? _cachedUser;

  static Future<User> getUser() async {
    if (_cachedUser != null) {
      return _cachedUser!;
    }

    // Generate a random ID and create a user with coins
    final randomId = Random().nextInt(100000).toString();
    _cachedUser = User(
      id: randomId,
      name: 'Guest User',
      email: 'guest_$randomId@example.com',
      walletCoin: Random().nextInt(1000), // Initial wallet coins
    );

    return _cachedUser!;
  }

  static void setUser(User user) {
    _cachedUser = user;
  }

  static void clearCache() {
    _cachedUser = null;
  }

  // Optional: update coins
  static void addCoins(int amount) {
    if (_cachedUser != null) {
      _cachedUser = _cachedUser!.copyWith(
        walletCoin: _cachedUser!.walletCoin + amount,
      );
    }
  }

  static void deductCoins(int amount) {
    if (_cachedUser != null && _cachedUser!.walletCoin >= amount) {
      _cachedUser = _cachedUser!.copyWith(
        walletCoin: _cachedUser!.walletCoin - amount,
      );
    }
  }
}
