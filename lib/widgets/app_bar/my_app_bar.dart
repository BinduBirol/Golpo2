import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../service/UserService.dart';
import '../button/button_decorators.dart';

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

    // Fallback color for gradient top if null
    final Color topGradientColor =
        appBarTheme.backgroundColor ?? const Color(0xFFB71C1C);

    return Stack(
      children: [
        AppBar(
          title: Text(
            title,
            style: TextStyle(
              color: appBarTheme.backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: ButtonDecorators.circularIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: () {
              Navigator.of(context).pop();
            },
            iconColor: appBarTheme.foregroundColor,
            backgroundColor: appBarTheme.backgroundColor,
            padding: const EdgeInsets.only(left: 16),
          ),
          actions:
              actions ??
              [
                ValueListenableBuilder<int>(
                  valueListenable: UserService.walletCoinNotifier,
                  builder: (context, walletCoin, _) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/buy'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.orange, width: 1),
                          ),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.coins,
                                color: Colors.deepOrange,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                NumberFormat.decimalPattern(
                                  Localizations.localeOf(context).toString(),
                                ).format(walletCoin),
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
          elevation: 0,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  topGradientColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
