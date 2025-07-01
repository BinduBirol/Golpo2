import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonDecorators {
  static const double _buttonHeight = 30.0;
  static const double _iconSize = 20.0;

  /// Circular filled icon button
  static Widget circularIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? iconColor,
    Color? backgroundColor,
    double size = _iconSize,
    EdgeInsets padding = const EdgeInsets.all(8.0),
    double? height
  }) {
    return Padding(
      padding: padding,
      child: Container(
        width: _buttonHeight,
        height:  height ?? _buttonHeight,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white24,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: FaIcon(icon, color: iconColor ?? Colors.white, size: size),
          onPressed: onPressed,
          splashRadius: size + 8,
        ),
      ),
    );
  }

  /// Filled elevated button with icon and text
  static Widget defaultButton({
    Key? key,
    required BuildContext context,
    required IconData icon,
    bool iconIsFaIcon = false,
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? labelTextStyle,
  }) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final bgColor =
        backgroundColor ?? appBarTheme.backgroundColor ?? Colors.blue;
    final fgColor =
        foregroundColor ?? appBarTheme.foregroundColor ?? Colors.white;

    final Widget iconWidget = iconIsFaIcon
        ? FaIcon(icon, color: fgColor, size: _iconSize)
        : Icon(icon, color: fgColor, size: _iconSize);

    return ElevatedButton.icon(
      key: key,
      onPressed: onPressed,
      icon: iconWidget,
      label: Text(text, style: labelTextStyle),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        fixedSize: const Size.fromHeight(_buttonHeight),
        shape: const StadiumBorder(), // 👈 Fully rounded
      ),
    );
  }
}
