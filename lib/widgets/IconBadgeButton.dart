import 'package:flutter/material.dart';

class IconBadgeButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final String count;
  final VoidCallback? onPressed;

  const IconBadgeButton({
    Key? key,
    required this.icon,
    required this.backgroundColor,
    required this.count,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        fixedSize: const Size(40, 40),
        padding: EdgeInsets.zero,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Icon(icon, size: 20),
          ),
          if (count.isNotEmpty)
            Positioned(
              right: -6, // slightly outside right edge
              top: -6,     // inside vertical bounds to avoid lifting
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow( // subtle shadow for better readability
                      offset: Offset(0, 0),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
