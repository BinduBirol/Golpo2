import 'package:flutter/material.dart';
import 'package:golpo/book/content/service/BookContentService.dart';

import '../../DTO/Book.dart';
import '../../DTO/content/Line.dart';
import 'ChapterReadingPage.dart';

class BookContentPage extends StatefulWidget {
  final Book book;

  const BookContentPage({super.key, required this.book});

  @override
  State<BookContentPage> createState() => _BookContentPageState();
}

class _BookContentPageState extends State<BookContentPage> {
  bool isLoading = true;
  List<Chapter> chapters = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _prepareBookContent();
  }

  Future<void> _prepareBookContent() async {
    try {
      /*
      if (kIsWeb) {
        chapters = await BookContentService.loadChapters(widget.book);
      } else {
        chapters = await BookContentService.loadChaptersFromLocalCache(
          widget.book,
        );
      }

      */
      chapters = await BookContentService.loadChapters(widget.book);
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = null;
      });

      if (chapters.length == 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ChapterReadingPage(
                book: widget.book,
                chapter: chapters.first,
              ),
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "লোড করতে সমস্যা হয়েছে: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('লোড হচ্ছে...'),
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ত্রুটি'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Text(
            errorMessage!,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("অধ্যায়সমূহ"),
        backgroundColor: Colors.deepPurple,
      ),
      body: chapters.isEmpty
          ? const Center(child: Text("এই বইয়ে কোনো অধ্যায় নেই।"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Text(
                        '${chapter.chapterNumber}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(
                      "অধ্যায় ${chapter.chapterNumber}: ${chapter.title}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChapterReadingPage(
                            book: widget.book,
                            chapter: chapter,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
