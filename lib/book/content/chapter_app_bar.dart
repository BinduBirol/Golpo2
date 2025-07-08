// chapter_app_bar.dart
import 'package:flutter/material.dart';

class ChapterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String chapterTitle;
  final bool autoPlay;
  final bool musicOn;
  final VoidCallback onAutoPlayToggle;
  final VoidCallback onMusicToggle;

  const ChapterAppBar({
    Key? key,
    required this.chapterTitle,
    required this.autoPlay,
    required this.musicOn,
    required this.onAutoPlayToggle,
    required this.onMusicToggle,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(chapterTitle),
      backgroundColor: Colors.deepPurple,
      actions: [
        IconButton(
          icon: Icon(
            autoPlay ? Icons.play_circle_fill : Icons.play_circle_outline,
            color: Colors.white,
          ),
          tooltip: autoPlay ? 'Autoplay On' : 'Autoplay Off',
          onPressed: onAutoPlayToggle,
        ),
        IconButton(
          icon: Icon(
            musicOn ? Icons.music_note : Icons.music_off,
            color: Colors.white,
          ),
          tooltip: musicOn ? 'Music On' : 'Music Off',
          onPressed: onMusicToggle,
        ),
      ],
    );
  }
}
