import 'package:flutter/material.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appPrimaryColor = Theme.of(context).appBarTheme.backgroundColor;

    return DrawerHeader(
      decoration: BoxDecoration(
        color: appPrimaryColor,
      ),
      child: Row(
        children: [
          // Left: User icon with app color background
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: appPrimaryColor,
            ),
          ),

          SizedBox(width: 16),

          // Right: 2 lines of text
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line 1: User ID
                Text(
                  'User ID : 123',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 8),

                // Line 2: Following and Followers combined
                Text(
                  'Followers 350',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
