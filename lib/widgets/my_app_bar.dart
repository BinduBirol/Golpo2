import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../DTO/User.dart';

import '../service/UserService.dart';
import 'AppbarFaIcon.dart';

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: appBarTheme.foregroundColor),
        onPressed: () {
          Navigator.of(context).pop();
        },
        tooltip: 'Back',
      ),
      actions: actions ??
          [
            FutureBuilder<User>(
              future: UserService.getUser(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(); // or a loading spinner
                }

                final user = snapshot.data!;

                return TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/story'),
                  label: Text(
                    '${user.walletCoin}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.coins,
                    color: Colors.orange,
                    size: 22,
                  ),

                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                    //padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                );
              },
            ),
          ],
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
