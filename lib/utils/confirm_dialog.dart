import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
}) {
  // Assign default values here using context
  final confirm = confirmText ?? AppLocalizations.of(context)!.yes;
  final cancel = cancelText ?? AppLocalizations.of(context)!.no;

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirm),
        ),
      ],
    ),
  );
}
