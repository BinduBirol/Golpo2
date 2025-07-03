import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:golpo/widgets/wallet_coin_chip.dart';

import '../../service/UserService.dart';
import '../button/button_decorators.dart';

class BookAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const BookAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    // Use fallback color if backgroundColor is null
    final Color topGradientColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  topGradientColor,
                  topGradientColor.withOpacity(0.9),
                  topGradientColor.withOpacity(0.4),
                  topGradientColor.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
        AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                // Translucent dark background
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white, // White for contrast
                tooltip: 'Back',
              ),
            ),
          ),
          actions:
              actions ??
              [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                        const WalletCoinChip(), // WalletChip text/icon should be white too
                  ),
                ),
              ],

          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
          elevation: 0,
          title: Text(
            title,
            style: TextStyle(
              color: foregroundColor ?? appBarTheme.foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
