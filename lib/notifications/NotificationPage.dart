import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golpo/widgets/my_app_bar.dart';

import '../l10n/app_localizations.dart';

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
