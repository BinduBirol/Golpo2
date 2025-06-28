import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppbarFaIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const AppbarFaIcon({
    Key? key,
    required this.icon,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get appBarTheme foregroundColor if available, else iconTheme.color or black
    final appBarTheme = Theme.of(context).appBarTheme;
    final iconColor = color ?? appBarTheme.foregroundColor ?? IconTheme.of(context).color ?? Colors.black;

    return FaIcon(
      icon,
      size: size,
      color: iconColor,
    );
  }
}
