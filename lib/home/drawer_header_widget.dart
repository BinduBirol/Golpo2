import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../DTO/User.dart';
import '../service/UserService.dart';

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
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
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
              SizedBox(
                height: 50, // total height
                width: 50,  // total width
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: appPrimaryColor),
                ),
              ),


              const SizedBox(width: 16),

              // Right: Text Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (user.isVerified)
                          const Row(
                            children: [
                              SizedBox(width: 8),
                              FaIcon(
                                Icons.verified_user,
                                size: 16,
                                color: Colors.greenAccent,
                              ),
                            ],
                          ),
                      ],
                    ),

                    // Line 1: User ID
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/buy'),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.coins,
                                size: 16,
                                color: Colors.amberAccent,
                              ),
                              const SizedBox(width: 6),
                              ValueListenableBuilder<int>(
                                valueListenable: UserService.walletCoinNotifier,
                                builder: (context, coinValue, _) {
                                  return Text(
                                    NumberFormat.decimalPattern(
                                      Localizations.localeOf(
                                        context,
                                      ).toString(),
                                    ).format(coinValue),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.amberAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                          child: Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.users,
                                size: 16,
                                color: Colors.tealAccent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                NumberFormat.decimalPattern(
                                  Localizations.localeOf(context).toString(),
                                ).format(user.followers),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Line 2: Wallet coins with navigation
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
