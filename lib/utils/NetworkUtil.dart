import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:http/http.dart' as http;

class NetworkUtil {
  static Future<bool> hasInternet() async {
    // Step 1: Check for any kind of network connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Step 2: Attempt to access a known online resource
    try {
      final url = kIsWeb
          ? 'https://jsonplaceholder.typicode.com/posts/1' // CORS-friendly
          : 'https://clients3.google.com/generate_204';    // Lightweight for mobile

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      // 200 for jsonplaceholder, 204 for google
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
