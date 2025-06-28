import 'package:flutter/material.dart';

String getFontFamily(BuildContext context) {
  final locale = Localizations.localeOf(context);
  return locale.languageCode == 'bn' ? 'nikosh' : 'amita';
}
