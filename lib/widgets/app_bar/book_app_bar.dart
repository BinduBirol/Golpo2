import 'package:flutter/material.dart';
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
    final Color topGradientColor = appBarTheme.backgroundColor ?? const Color(0xFFB71C1C);

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
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        AppBar(
          leading: ButtonDecorators.circularIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: () => Navigator.of(context).pop(),
            iconColor: appBarTheme.foregroundColor,
            backgroundColor: appBarTheme.backgroundColor,
            padding: const EdgeInsets.only(left: 12),
          ),
          actions: actions ??
              [
                ValueListenableBuilder<int>(
                  valueListenable: UserService.walletCoinNotifier,
                  builder: (context, walletCoin, _) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: WalletCoinChip(),
                    );
                  },
                ),
              ],
          backgroundColor: backgroundColor ?? Colors.transparent,
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
