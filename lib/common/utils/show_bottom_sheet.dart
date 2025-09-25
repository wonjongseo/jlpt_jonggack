import 'package:flutter/material.dart';

Future showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
}) async {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            child,
            SizedBox(height: 10 * 5),
          ],
        ),
      );
    },
  );
}
