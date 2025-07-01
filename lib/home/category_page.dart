import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_bar/my_app_bar.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
      appBar: MyAppBar(title: 'Library'),
      body: Row(
        children: [
          Text(
            'Category List',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            'Books',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
