import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart'; // For ValueNotifier
import 'package:shared_preferences/shared_preferences.dart';

import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';

class UserService {
  static User? _cachedUser;

  // ValueNotifier to notify listeners about coin updates
  static final ValueNotifier<int> walletCoinNotifier = ValueNotifier<int>(0);

  // Key for SharedPreferences user data
  static const _userPrefsKey = 'user_preferences';
  static const _userWalletKey = 'user_wallet_coin';

  // Get user, from cache if possible
  static Future<User> getUser() async {
    if (_cachedUser != null) return _cachedUser!;

    final prefs = await SharedPreferences.getInstance();

    final prefJson = prefs.getString(_userPrefsKey);

    final userPreferences = prefJson != null
        ? UserPreferences.fromJson(jsonDecode(prefJson))
        : UserPreferences.defaultValues();

    // Load wallet coin from prefs or generate random for first time
    final walletCoin = prefs.getInt(_userWalletKey) ?? Random().nextInt(100);

    final randomId = Random().nextInt(100000).toString();

    _cachedUser = User(
      id: randomId,
      name: 'Guest Karmaker Overoy',
      email: 'guest_$randomId@example.com',
      walletCoin: walletCoin,
      isVerified: false,
      followers: Random().nextInt(100),
      preferences: userPreferences,
    );

    // Update notifier so UI gets initial value
    walletCoinNotifier.value = _cachedUser!.walletCoin;

    return _cachedUser!;
  }

  // Save user preferences and wallet coins persistently
  static Future<void> _saveUserToPrefs() async {
    if (_cachedUser == null) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userPrefsKey, jsonEncode(_cachedUser!.preferences.toJson()));
    await prefs.setInt(_userWalletKey, _cachedUser!.walletCoin);
  }

  static Future<void> setUser(User user) async {
    _cachedUser = user;
    walletCoinNotifier.value = user.walletCoin;

    await _saveUserToPrefs();
  }

  static void clearCache() {
    _cachedUser = null;
    walletCoinNotifier.value = 0;
  }

  static Future<void> addCoins(int amount) async {
    if (_cachedUser != null) {
      _cachedUser = _cachedUser!.copyWith(
        walletCoin: _cachedUser!.walletCoin + amount,
      );
      walletCoinNotifier.value = _cachedUser!.walletCoin;
      await _saveUserToPrefs();
    }
  }

  // Return updated User or null if insufficient coins
  static Future<User?> deductCoins(int amount) async {
    if (_cachedUser != null && _cachedUser!.walletCoin >= amount) {
      _cachedUser = _cachedUser!.copyWith(
        walletCoin: _cachedUser!.walletCoin - amount,
      );
      walletCoinNotifier.value = _cachedUser!.walletCoin;
      await _saveUserToPrefs();
      return _cachedUser!;
    }
    return null;
  }
}
