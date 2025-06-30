import 'package:flutter/material.dart';

class ScrollableCategoryList extends StatelessWidget {
  final List<String> categories;
  final void Function(String)? onTap;

  const ScrollableCategoryList({
    super.key,
    required this.categories,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isFirst = index == 0;

        return Padding(
          padding: EdgeInsets.only(
            left: isFirst ? 0 : 6, // no left padding for first item
            right: 6,
          ),
          child: GestureDetector(
            onTap: () => onTap?.call(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              // reduce vertical padding slightly
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.0,
                  // tight line height to avoid extra vertical space
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
