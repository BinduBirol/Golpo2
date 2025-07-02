import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../service/UserService.dart';
import '../wallet_coin_chip.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const MyAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    final Color topGradientColor =
        appBarTheme.backgroundColor ?? const Color(0xFFB71C1C);

    return Stack(
      children: [
        // 🔽 Gradient is drawn in the background
        /*
        Container(
          height: preferredSize.height,
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
        */

        // 🔼 AppBar is drawn above the gradient
        AppBar(
          title: Text(
            title,
            style: TextStyle(
              //color: appBarTheme.backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
            //color: appBarTheme.backgroundColor,
            tooltip: 'back',
            //padding: const EdgeInsets.only(left: 16),
          ),

          actions:
              actions ??
              [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: WalletCoinChip(),
                ),
              ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          //foregroundColor: backgroundColor ?? appBarTheme.backgroundColor,
        ),
      ],
    );
  }
}
