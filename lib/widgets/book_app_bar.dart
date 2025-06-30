import 'package:flutter/material.dart';
import 'package:golpo/widgets/wallet_coin_chip.dart';

import '../service/UserService.dart';

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

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              //padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              width: double.infinity,
              height: 40,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        AppBar(
          //title: Text(title),
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: appBarTheme.backgroundColor,
                foregroundColor: appBarTheme.foregroundColor,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                elevation: 2,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          ),
          actions:
              actions ??
              [
                ValueListenableBuilder<int>(
                  valueListenable: UserService.walletCoinNotifier,
                  builder: (context, walletCoin, _) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: WalletCoinChip(),
                    );
                  },
                ),
              ],
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
          elevation: 0,
        ),

        // Floating top-center book name
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
