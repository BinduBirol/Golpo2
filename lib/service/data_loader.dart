// service/data_loader.dart
import 'dart:async';
import 'package:golpo/service/BookService.dart';
import 'package:golpo/service/UserService.dart';

class DataLoader {
  static Future<void> loadDataWithProgress(
      Function(double progress, String stage) onProgress,
      ) async {
    const steps = 5;

    // Step 1: Start download
    onProgress(1 / steps, "Downloading book data...");
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    await BookService.fetchBooks(); // Fetch once

    // Step 2: Simulate validation step
    onProgress(2 / steps, "Validating data...");
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 3: Caching or preparing data
    onProgress(3 / steps, "Delaying...");
    await Future.delayed(const Duration(milliseconds: 300));

    onProgress(4 / steps, "Downloading user...");
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    await UserService.getUser(); // Fetch once

    onProgress(5 / steps, "Preparing for launch...");
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
