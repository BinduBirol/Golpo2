import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:golpo/service/BookService.dart';
import 'package:golpo/service/UserService.dart';
import '../DTO/Book.dart';
import '../DTO/User.dart';
import '../DTO/UserPreferences.dart';
import '../utils/NetworkUtil.dart';

class DataLoader {
  static Future<void> loadDataWithProgress(
      Function(double progress, String stage) onProgress,
      ) async {
    const steps = 8;
    int i = 0;

    onProgress(i++ / steps, "Checking previous session...");

    // Load existing user
    User user = await UserService.getUser();

    // If user is signed in to Firebase (Google), override guest user
    final fbUser = fb.FirebaseAuth.instance.currentUser;
    if (fbUser != null) {
      print("[DataLoader] Firebase user detected. Overriding guest user.");
      user = User(
        id: fbUser.uid,
        googleId: fbUser.providerData.isNotEmpty ? fbUser.providerData.first.uid : null,
        photoUrl: fbUser.photoURL,
        name: fbUser.displayName ?? '',
        email: fbUser.email ?? '',
        walletCoin: user.walletCoin, // retain previous coins
        isVerified: fbUser.emailVerified,
        followers: user.followers, // retain previous followers
        preferences: user.preferences,
      );

      await UserService.setUser(user); // persist updated Google user
    }

    onProgress(i++ / steps, "Checking internet connection...");
    final isConnected = await NetworkUtil.hasInternet();

    if (!isConnected) {
      onProgress(i++ / steps, "No internet connection - offline mode.");
    } else {
      onProgress(i++ / steps, "Internet connection established.");
    }

    onProgress(i++ / steps, "Updating user data...");
    user = user.copyWith(
      preferences: user.preferences.copyWith(isConnected: isConnected),
    );
    await UserService.setUser(user);

    onProgress(i++ / steps, "User data updated.");

    onProgress(i++ / steps, "Copying assets to local storage...");
    bool isCopied = await BookService.copyAssetJsonToLocalStorage();
    onProgress(i++ / steps, "Assets copy ${isCopied ? "successful." : "failed."}");

    onProgress(i++ / steps, "Verifying offline book data...");
    List<Book> books = await BookService.fetchBooks();

    onProgress(i++ / steps, "Caching book covers...");
    await BookService.cacheCovers(books);
  }
}
