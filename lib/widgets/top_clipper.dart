import 'package:flutter/material.dart';

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double slantHeight = 12;
    final path = Path();

    // Start at top-left inward slant
    path.moveTo(0, slantHeight);
    path.lineTo(size.width * 0.1, 0);

    // Top edge to top-right inward slant
    path.lineTo(size.width * 0.9, 0);
    path.lineTo(size.width, slantHeight);

    // Right side straight down
    path.lineTo(size.width, size.height - 12);

    // Bottom curved inward (semi-circle like)
    path.quadraticBezierTo(
      size.width / 2, size.height + 12,
      0, size.height - 12,
    );

    // Left side straight up
    path.lineTo(0, slantHeight);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
