import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class LikeIcon extends StatelessWidget {
  const LikeIcon({
    super.key,
    required this.isSaved,
    this.iconSize,
    required this.onTap,
  });

  final bool isSaved;
  final Function() onTap;
  final double? iconSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: FaIcon(
            isSaved
                ? FontAwesomeIcons.solidBookmark
                : FontAwesomeIcons.bookmark,
            color: isSaved ? SettingController.to.mainBordColor : null,
            size: iconSize ?? 22,
          ),
        ),
      ),
    );
  }
}
