// chapter_app_bar.dart
import 'package:flutter/material.dart';
import 'package:golpo/DTO/Book.dart';

class ChapterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String chapterTitle;
  final Book book;
  final bool autoPlay;
  final bool musicOn;
  final VoidCallback onAutoPlayToggle;
  final VoidCallback onMusicToggle;

  const ChapterAppBar({
    Key? key,
    required this.chapterTitle,
    required this.book,
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
        //color: appBarTheme.backgroundColor,
        tooltip: 'back',
        //padding: const EdgeInsets.only(left: 16),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(book.title,
            style: TextStyle(
              fontSize: 8,
              color: Colors.greenAccent
            ),
          ),
          Text(chapterTitle,style: TextStyle(
              fontSize: 12
          ),)
        ],
      ),
      //backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0, // Optional: remove shadow
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              ?Theme.of(context).appBarTheme.backgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
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
