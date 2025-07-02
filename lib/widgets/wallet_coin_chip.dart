// lib/widgets/wallet_coin_container.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../service/UserService.dart';

class WalletCoinChip extends StatelessWidget {
  const WalletCoinChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: UserService.walletCoinNotifier,
      builder: (context, walletCoin, _) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/buy'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amberAccent, width: 1),
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.coins,
                  color: Colors.amberAccent,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  NumberFormat.decimalPattern(
                    Localizations.localeOf(context).toString(),
                  ).format(walletCoin),
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
