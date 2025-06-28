import 'package:flutter/material.dart';
import 'package:golpo/widgets/my_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? ageGroup;

  @override
  void initState() {
    super.initState();
    _loadAgeGroup();
  }

  Future<void> _loadAgeGroup() async {
    final prefs = await SharedPreferences.getInstance();
    final group = prefs.getString('age_group');

    setState(() {
      ageGroup = group ?? 'Not set';
    });
  }

  String getReadableGroup(String? group) {
    switch (group) {
      case 'under_18':
        return 'Under 18';
      case '18_30':
        return '18 – 30';
      case 'over_30':
        return 'Over 30';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 80, color: Colors.deepPurple),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to your profile!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Your Age Group:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    getReadableGroup(ageGroup),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
