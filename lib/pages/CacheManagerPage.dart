import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'dart:io' as io;
import 'package:golpo/widgets/app_bar/my_app_bar.dart';

class CacheManagerPage extends StatefulWidget {
  const CacheManagerPage({super.key});

  @override
  State<CacheManagerPage> createState() => _CacheManagerPageState();
}

class _CacheManagerPageState extends State<CacheManagerPage> {
  int _cacheSizeBytes = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadCacheSize();
    }
  }

  Future<void> _loadCacheSize() async {
    setState(() => _isLoading = true);
    final dir = await _getBooksCacheDir();
    final size = await _calculateDirectorySize(dir);
    setState(() {
      _cacheSizeBytes = size;
      _isLoading = false;
    });
  }

  Future<io.Directory> _getBooksCacheDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    return io.Directory(p.join(appDir.path, 'books'));
  }

  Future<int> _calculateDirectorySize(io.Directory dir) async {
    if (!await dir.exists()) return 0;

    int total = 0;
    await for (io.FileSystemEntity entity in dir.list(recursive: true)) {
      if (entity is io.File) {
        total += await entity.length();
      }
    }
    return total;
  }

  Future<void> _clearCache() async {
    final dir = await _getBooksCacheDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await _loadCacheSize();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Book image cache cleared')));
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(2)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Cache Manager"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: kIsWeb
            ? const Center(
                child: Text(
                  "Image caching is not supported on the web.",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book Image Cache Size: ${_formatSize(_cacheSizeBytes)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("Clear Cache"),
                    onPressed: _cacheSizeBytes == 0 ? null : _clearCache,
                  ),
                ],
              ),
      ),
    );
  }
}
