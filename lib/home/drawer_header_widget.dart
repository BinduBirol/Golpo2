import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../service/UserService.dart';
import '../DTO/User.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appPrimaryColor = Theme.of(context).appBarTheme.backgroundColor;

    return FutureBuilder<User>(
      future: UserService.getUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const DrawerHeader(
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        final user = snapshot.data!;

        return DrawerHeader(
          decoration: BoxDecoration(
            color: appPrimaryColor,
          ),
          child: Row(
            children: [
              // Left: User icon with white background
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: appPrimaryColor,
                ),
              ),

              const SizedBox(width: 16),

              // Right: Text Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line 1: User ID
                    Text(
                      'User ID : ${user.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Line 2: Wallet coins
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.coins,
                          size: 16,
                          color: Colors.amberAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${user.walletCoin} coins',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
