import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../service/UserService.dart';

class WalletCoinChip extends StatelessWidget {
  const WalletCoinChip({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: UserService.walletCoinNotifier,
      builder: (context, walletCoin, _) {
        final locale = Localizations.localeOf(context).toString();
        final formattedCoin = NumberFormat.decimalPattern(locale).format(walletCoin);

        return ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/buy'),
          icon: const FaIcon(
            FontAwesomeIcons.coins,
            size: 18,
            color: Colors.orangeAccent,
          ),
          label: Text(
            formattedCoin,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            fixedSize: const Size.fromHeight(40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 2,
            shadowColor: Colors.orange.withOpacity(0.2),
          ),
        );
      },
    );
  }
}
