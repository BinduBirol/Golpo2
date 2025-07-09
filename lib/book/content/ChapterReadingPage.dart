import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golpo/book/content/service/BookContentService.dart';
import 'package:golpo/book/content/utils/BookTextBackground.dart';
import 'package:golpo/service/UserService.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../DTO/Book.dart';
import '../../DTO/content/Line.dart';
import '../../DTO/content/ReadingProgress.dart';
import 'book_text_background.dart';
import 'chapter_app_bar.dart';

class ChapterReadingPage extends StatefulWidget {
  final Book book;
  final Chapter chapter;

  const ChapterReadingPage({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  State<ChapterReadingPage> createState() => _ChapterReadingPageState();
}

class _ChapterReadingPageState extends State<ChapterReadingPage> {
  int _currentParagraphIndex = 0;
  int _currentLineIndex = 0;
  bool _isTyping = true;
  bool _isChapterEnd = false;
  bool _currentLineFinished = false;
  bool _showChapterTitleFirst = true;

  bool _autoPlay = false; // to track autoplay on/off
  bool _musicOn = false; // to track music on/off

  final List<String> _paragraphBackgroundImages = [
    "https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "https://images.pexels.com/photos/374710/pexels-photo-374710.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  ];

  final String _chapterTitleBackground =
      "https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260";

  final ScrollController _scrollController = ScrollController();

  final GlobalKey<TypewriterTextState> _typewriterKey =
      GlobalKey<TypewriterTextState>();

  @override
  void initState() {
    super.initState();

    // Load last reading progress
    final progress = ReadingProgress.lastRead[widget.book.id];
    if (progress != null) {
      _currentParagraphIndex = progress["paragraph"]!;
      _currentLineIndex = progress["line"]!;
    }

    _isTyping = true;
    _isChapterEnd = false;
    _currentLineFinished = false;

    // ✅ Load autoplay and music preferences from user
    _loadUserPreferences();
  }

  void _loadUserPreferences() async {
    final user = await UserService.getUser();
    setState(() {
      _autoPlay = user.preferences.autoReadEnabled;
      _musicOn = user.preferences.sfxEnabled;
    });

    // Wake lock if autoplay is enabled
    WakelockPlus.toggle(enable: _autoPlay);

    // Start autoplay if it's enabled
    if (_autoPlay) _playNextLine();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String get currentBackground {
    if (_showChapterTitleFirst) {
      return _chapterTitleBackground;
    }
    // Cycle paragraph background images by paragraph index
    return _paragraphBackgroundImages[_currentParagraphIndex %
        _paragraphBackgroundImages.length];
  }

  void _playNextLine() {
    if (!_isChapterEnd) {
      _onTapNext();
      if (_autoPlay) {
        Future.delayed(const Duration(seconds: 2), _playNextLine);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;

    return Scaffold(
      appBar: ChapterAppBar(
        chapterTitle: "অধ্যায় ${chapter.chapterNumber}: ${chapter.title}",
        book: widget.book,
        autoPlay: _autoPlay,
        musicOn: _musicOn,
        onAutoPlayToggle: () {
          setState(() {
            _autoPlay = !_autoPlay;
            WakelockPlus.toggle(enable: _autoPlay);
            if (_autoPlay) _playNextLine();
          });
          try {
            UserService.updateAutoReadPreference(_autoPlay);
          } catch (e) {
            debugPrint('Failed to save autoplay preference: $e');
          }
        },
        onMusicToggle: () {
          setState(() {
            _musicOn = !_musicOn;
            // Add music logic here if you want
          });

          try {
            UserService.updateMusicPreference(_musicOn);
          } catch (e) {
            debugPrint('Failed to save music preference: $e');
          }
        },
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTapNext,
        child: Stack(
          children: [
            // Fullscreen background with fade animation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Container(
                key: ValueKey(currentBackground),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(currentBackground),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Foreground content with padding and SafeArea
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _showChapterTitleFirst
                    ? _buildChapterTitleView()
                    : widget.chapter.paragraphs.isEmpty
                    ? const Center(
                        child: Text(
                          "এই অধ্যায়ে কোনো অনুচ্ছেদ নেই।",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment:
                            MainAxisAlignment.end, // push to bottom
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              // margin at bottom
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: BookTextBackground(
                                  child: _buildCurrentContent(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildChapterTitleView() {
    final chapter = widget.chapter;

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset(
            'assets/img/chapter_bg1.png',
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),



          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "অধ্যায় ${chapter.chapterNumber}",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        offset: Offset(2, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),



                const SizedBox(height: 16),
                Text(
                  chapter.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        offset: Offset(1, 1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Tap to start reading",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }





  Widget _buildChapterTitleView_old() {
    final chapter = widget.chapter;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "অধ্যায় ${chapter.chapterNumber}",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  offset: Offset(2, 2),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            chapter.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  offset: Offset(1, 1),
                  blurRadius: 5,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          const Text(
            "Tap to start reading",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentContent() {
    final paragraph = widget.chapter.paragraphs[_currentParagraphIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...paragraph.lines.asMap().entries.map((entry) {
          final lineIndex = entry.key;
          final line = entry.value;

          if (lineIndex < _currentLineIndex) {
            // Already fully shown lines
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line.text,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            );
          } else if (lineIndex == _currentLineIndex) {
            // Current animating line
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TypewriterText(
                key: ValueKey(
                  'line_$_currentParagraphIndex-$_currentLineIndex',
                ),
                text: line.text,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.white,
                ),
                onComplete: () {
                  setState(() {
                    _isTyping = false;
                    _currentLineFinished = true;
                  });
                  _scrollToBottom();
                },
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList(),

        const SizedBox(height: 12),

        if (_isChapterEnd)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                final allChapters = await BookContentService.loadChapters(
                  widget.book,
                );
                final currentChapterIndex = allChapters.indexWhere(
                  (c) => c.chapterNumber == widget.chapter.chapterNumber,
                );

                if (currentChapterIndex + 1 < allChapters.length) {
                  final nextChapter = allChapters[currentChapterIndex + 1];
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChapterReadingPage(
                        book: widget.book,
                        chapter: nextChapter,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("আর কোনো অধ্যায় নেই।")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("অধ্যায় লোড করতে সমস্যা হয়েছে।"),
                  ),
                );
              }
            },
            child: const Text("পরবর্তী অধ্যায়"),
          )
        else if (!_isTyping)
          const Text(
            "Tap to continue...",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  void _onTapNext() {
    if (_isChapterEnd) return;

    if (_showChapterTitleFirst) {
      setState(() {
        _showChapterTitleFirst = false;
      });
      return;
    }

    final chapter = widget.chapter;
    final paragraph = chapter.paragraphs[_currentParagraphIndex];

    if (!_currentLineFinished) {
      // Animation still running, skip to full text
      _typewriterKey.currentState?.skip();
      setState(() {
        _isTyping = false;
        _currentLineFinished = true;
      });
      _scrollToBottom();
      return;
    }

    // Animation finished, move to next line or paragraph
    setState(() {
      if (_currentLineIndex < paragraph.lines.length - 1) {
        _currentLineIndex++;
        _isTyping = true;
        _currentLineFinished = false;
      } else if (_currentParagraphIndex < chapter.paragraphs.length - 1) {
        _currentParagraphIndex++;
        _currentLineIndex = 0;
        _isTyping = true;
        _currentLineFinished = false;
      } else {
        _isChapterEnd = true;
        _isTyping = false;
        _currentLineFinished = true;
      }
    });

    _scrollToBottom();
  }
}
