import 'package:flutter/material.dart';

class BookTextBackground extends StatelessWidget {
  final Widget child;

  const BookTextBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // full width container
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87.withOpacity(0.7), // dark translucent background
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
