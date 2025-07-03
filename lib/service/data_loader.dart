import 'dart:async';
import 'package:golpo/service/BookService.dart';
import 'package:golpo/service/UserService.dart';

import '../DTO/Book.dart';
import '../DTO/User.dart';

import '../utils/NetworkUtil.dart';

class DataLoader {
  static Future<void> loadDataWithProgress(
    Function(double progress, String stage) onProgress,
  ) async {
    const steps = 9;
    int i = 0;

    onProgress(i++ / steps, "Checking previous session...");
    await Future.delayed(const Duration(milliseconds: 1500)); // Simulate delay
    User user = await UserService.getUser(); // Fetch once

    onProgress(i++ / steps, "Checking internet connection...");
    await Future.delayed(const Duration(milliseconds: 1500));
    final isConnected = await NetworkUtil.hasInternet();
    if (!isConnected) {
      onProgress(i++ / steps, "Offline mode: No internet connection.");
    } else {
      onProgress(i++ / steps, "Internet connected.");
    }
    await Future.delayed(const Duration(milliseconds: 1500));

    onProgress(i++ / steps, "Updating user...");
    await Future.delayed(const Duration(milliseconds: 1500));
    user = user.copyWith(
      preferences: user.preferences.copyWith(isConnected: isConnected),
    );

    print("Updated user connection : ${user.preferences.isConnected}");
    onProgress(
      i++ / steps,
      "Updated user connection : ${user.preferences.isConnected}",
    );
    await Future.delayed(const Duration(milliseconds: 1500));
    // Step 1: Start download
    onProgress(i++ / steps, "Verifying offline book data...");
    await Future.delayed(const Duration(milliseconds: 1500)); // Simulate delay
    List<Book> books = await BookService.fetchBooks(); // Fetch once

    onProgress(i++ / steps, "Caching book covers...");
    await Future.delayed(const Duration(milliseconds: 1500)); // Simulate delay
    await BookService.cacheCovers(books);

    // Step 2: Simulate validation step
    onProgress(i++ / steps, "Just a delay...");
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 3: Caching or preparing data
    onProgress(i++ / steps, "Delaying...");
    await Future.delayed(const Duration(milliseconds: 500));

    onProgress(i++ / steps, "Preparing for launch...");
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
