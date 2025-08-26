// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jlpt_jonggack/config/colors.dart';

// class AppDialog {

//   static Future<bool> selectionDialog({Widget? title, Widget? connent}) async {
//     return jonggackDialog(
//       title: title,
//       connent: connent,
//       action: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           GestureDetector(
//             onTap: () => Get.back(result: true),
//             child: Container(
//               width: 80,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryColor,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Center(
//                 child: Text(
//                   AppString.yesText.tr,
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(width: 10),
//           GestureDetector(
//             onTap: () => Get.back(result: false),
//             child: Container(
//               width: 80,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryColor,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Center(
//                 child: Text(
//                   AppString.noText.tr,
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static Future<bool> jonggackDialog({
//     Widget? title,
//     Widget? connent,
//     Widget? action,
//   }) async {
//     bool result = await Get.dialog(
//       barrierDismissible: false,
//       AlertDialog(
//         shape: Border.all(),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (title != null) ...[title, SizedBox(height: 20)],
//             if (connent != null) ...[connent, SizedBox(height: 20)],
//             // const Align(alignment: Alignment.center, child: JonggackAvator()),
//             if (action != null) ...[
//               SizedBox(height: 20),
//               action,
//               SizedBox(height: 10),
//             ],
//           ],
//         ),
//       ),
//     );

//     return result;
//   }
// }
