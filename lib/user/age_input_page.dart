import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

class AgeInputPage extends StatelessWidget {
  Future<void> _setAgeGroup(BuildContext context, String group) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('age_group', group);

    Navigator.pushReplacementNamed(context, '/story');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center content vertically
            children: [
              Text(
                AppLocalizations.of(context)!.welcomeText,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.ageGroupSelect,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => _setAgeGroup(context, 'under_18'),
                child: Text(AppLocalizations.of(context)!.under18),
              ),
              SizedBox(height: 12),

              ElevatedButton(
                onPressed: () => _setAgeGroup(context, '18_30'),
                child: Text(AppLocalizations.of(context)!.ageGroup18to30),
              ),
              SizedBox(height: 12),

              ElevatedButton(
                onPressed: () => _setAgeGroup(context, 'over_30'),
                child: Text(AppLocalizations.of(context)!.over30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
