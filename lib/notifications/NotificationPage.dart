import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/app_bar/my_app_bar.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.notifications,
      ),
      body: Center(
        child: Text('Your notifications will appear here.'),
      ),
    );
  }
}
