import 'package:flutter/material.dart';

// N1~N5, My Word 등 카드
class LevelCategoryCard extends StatelessWidget {
  // Studying Card
  const LevelCategoryCard({
    super.key,
    required this.onTap,
    required this.title,
    this.body,
    this.foot,
    this.extraInfo,
  });
  final VoidCallback onTap;
  final String title;
  final Widget? body;
  final Widget? foot;
  final Widget? extraInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(4),
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16, right: 12, left: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                        ),
                      ),
                      const Divider(),
                      SizedBox(height: 6),
                      if (body != null) body!,
                      if (extraInfo != null) extraInfo!,
                    ],
                  ),
                  if (foot != null) foot!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
