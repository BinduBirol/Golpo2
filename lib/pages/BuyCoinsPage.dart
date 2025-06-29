import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:golpo/widgets/my_app_bar.dart';

import '../DTO/User.dart';
import '../service/UserService.dart';
import '../widgets/animated_coin.dart';

class BuyCoinsPage extends StatefulWidget {
  const BuyCoinsPage({super.key});

  @override
  State<BuyCoinsPage> createState() => _BuyCoinsPageState();
}

class _BuyCoinsPageState extends State<BuyCoinsPage> {
  final List<CoinPackage> packages = [
    CoinPackage(amount: 50, price: 0.99),
    CoinPackage(amount: 120, price: 1.99),
    CoinPackage(amount: 300, price: 4.99),
    CoinPackage(amount: 800, price: 9.99),
    CoinPackage(amount: 2000, price: 19.99),
  ];

  OverlayEntry? _overlayEntry;

  // We'll use a Map to store GlobalKeys for each package card for precise positioning
  final Map<int, GlobalKey> _cardKeys = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < packages.length; i++) {
      _cardKeys[i] = GlobalKey();
    }
  }

  Future<void> _buyCoins(BuildContext context, CoinPackage package, int index) async {
    final key = _cardKeys[index];
    if (key == null) return;

    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);

    _showCoinAnimation(position, renderBox.size);

    // Simulate payment delay or real payment process
    await Future.delayed(const Duration(seconds: 1));

    await UserService.addCoins(package.amount);

    Fluttertoast.showToast(
      msg: "Purchased ${package.amount} coins for \$${package.price}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green[700],
      textColor: Colors.white,
    );
  }

  void _showCoinAnimation(Offset position, Size size) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: position.dx + size.width / 2 - 24, // Center horizontally approx
          top: position.dy - 48, // A bit above the card
          child: AnimatedCoin(
            onEnd: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Buy Coins'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: packages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final package = packages[index];
            return GestureDetector(
              key: _cardKeys[index], // Assign key for position detection
              onTap: () => _buyCoins(context, package, index),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.coins,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${package.amount} Coins',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${package.price}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CoinPackage {
  final int amount;
  final double price;

  CoinPackage({required this.amount, required this.price});
}
