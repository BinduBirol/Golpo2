import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/app_bar/my_app_bar.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context)!.notifications),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,  // <-- add this
          children: [
            Image.network(
              'http://10.15.33.180:8080/images/book/1',
              errorBuilder: (context, error, stackTrace) {
                return const Text('Failed to load image');
              },
            ),
            Text('Your notifications will appear here.'),
          ],
        ),
      ),
    );
  }
}
