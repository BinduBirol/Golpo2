import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';
import 'google_auth_service.dart';

class UserService {
  static User? _cachedUser;

  static final ValueNotifier<int> walletCoinNotifier = ValueNotifier<int>(0);

  static const _userPrefsKey = 'user_preferences';
  static const _userWalletKey = 'user_wallet_coin';
  static const _userJsonKey = 'app_user_full_json';

  static Future<User> getUser() async {
    if (_cachedUser != null) return _cachedUser!;

    final prefs = await SharedPreferences.getInstance();

    // ✅ Load full user JSON if exists
    final userJsonString = prefs.getString(_userJsonKey);
    if (userJsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(userJsonString);
        _cachedUser = User.fromJson(jsonMap);
        walletCoinNotifier.value = _cachedUser!.walletCoin;
        return _cachedUser!;
      } catch (e) {
        print("[UserService] Error decoding stored user: $e");
      }
    }

    // Fallback: generate guest user
    final prefJson = prefs.getString(_userPrefsKey);
    final userPreferences = prefJson != null
        ? UserPreferences.fromJson(jsonDecode(prefJson))
        : UserPreferences.defaultValues();

    final walletCoin = prefs.getInt(_userWalletKey) ?? Random().nextInt(100);
    final randomId = Random().nextInt(100000).toString();

    _cachedUser = User(
      id: randomId,
      name: 'Guest User',
      email: 'guest_$randomId@example.com',
      walletCoin: walletCoin,
      isVerified: false,
      followers: Random().nextInt(100),
      preferences: userPreferences,
    );

    walletCoinNotifier.value = _cachedUser!.walletCoin;
    return _cachedUser!;
  }

  /// ✅ Save full User JSON persistently
  static Future<void> setUser(User user) async {
    _cachedUser = user;
    walletCoinNotifier.value = user.walletCoin;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());

    await prefs.setString(_userJsonKey, jsonString);
    await prefs.setString(_userPrefsKey, jsonEncode(user.preferences.toJson()));
    await prefs.setInt(_userWalletKey, user.walletCoin);
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
      await setUser(_cachedUser!);
    }
  }

  static Future<User?> deductCoins(int amount) async {
    if (_cachedUser != null && _cachedUser!.walletCoin >= amount) {
      _cachedUser = _cachedUser!.copyWith(
        walletCoin: _cachedUser!.walletCoin - amount,
      );
      walletCoinNotifier.value = _cachedUser!.walletCoin;
      await setUser(_cachedUser!);
      return _cachedUser!;
    }
    return null;
  }

  static Future<void> clearUser() async {
    _cachedUser = null;
    walletCoinNotifier.value = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userJsonKey);
    await prefs.remove(_userPrefsKey);
    await prefs.remove(_userWalletKey);

    // ✅ Google sign-out via your service
    try {
      final googleAuthService = GoogleAuthService();
      await googleAuthService.signOut();
      print("[UserService] Signed out from Google.");
    } catch (e) {
      print("[UserService] Error during Google sign-out: $e");
    }
  }


}
