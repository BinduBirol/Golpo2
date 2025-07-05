import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:golpo/service/BookService.dart';
import 'package:golpo/service/UserService.dart';

import '../DTO/Book.dart';
import '../DTO/User.dart';

import '../l10n/app_localizations.dart';
import '../utils/NetworkUtil.dart';

class DataLoader {
  static Future<void> loadDataWithProgress(
      Function(double progress, String stage) onProgress,
      ) async {
    const steps = 10;
    int i = 0;

    onProgress(i++ / steps, "Checking previous session...");
    await Future.delayed(const Duration(milliseconds: 1500));
    User user = await UserService.getUser();

    onProgress(i++ / steps, "Checking internet connection...");
    await Future.delayed(const Duration(milliseconds: 1500));
    final isConnected = await NetworkUtil.hasInternet();
    if (!isConnected) {
      onProgress(i++ / steps, "No internet connection - offline mode.");
    } else {
      onProgress(i++ / steps, "Internet connection established.");
    }
    await Future.delayed(const Duration(milliseconds: 1500));

    onProgress(i++ / steps, "Updating user data...");
    await Future.delayed(const Duration(milliseconds: 1500));
    user = user.copyWith(
      preferences: user.preferences.copyWith(isConnected: isConnected),
    );

    onProgress(i++ / steps, "User data updated.");
    await Future.delayed(const Duration(milliseconds: 1500));

    onProgress(i++ / steps, "Copying assets to local storage...");
    bool isCopied = await BookService.copyAssetJsonToLocalStorage();

    onProgress(i++ / steps, "Assets copy ${isCopied ? "successful." : "failed."}");
    await Future.delayed(const Duration(milliseconds: 1500));

    onProgress(i++ / steps, "Verifying offline book data...");
    await Future.delayed(const Duration(milliseconds: 1500));
    List<Book> books = await BookService.fetchBooks();

    onProgress(i++ / steps, "Caching book covers...");
    await Future.delayed(const Duration(milliseconds: 1500));
    await BookService.cacheCovers(books);

    onProgress(i++ / steps, "Finalizing...");
    await Future.delayed(const Duration(milliseconds: 1500));

    onProgress(i++ / steps, "Ready to launch.");
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
