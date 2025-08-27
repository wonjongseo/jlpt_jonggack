import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/widget/dimentions.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/search/controller/search_controller.dart';
import 'package:jlpt_jonggack/features/search/screens/search_screen.dart';
import 'package:jlpt_jonggack/user/controller/user_controller.dart';
import 'package:jlpt_jonggack/config/colors.dart';

List<String> list = ['일본어', '한자', '문법'];

// class NewSearchWidget extends StatelessWidget {
//   const NewSearchWidget({super.key, required this.isHomeScreen});
//   final bool isHomeScreen;

//   void search(query) {
//     print('isHomeScreen : ${isHomeScreen}');

//     if (isHomeScreen) {
//       Get.to(
//         () => SearchScreen(),
//         binding: BindingsBuilder.put(() => JSearchController()),
//         arguments: query,
//       );
//     }
//     if (Get.isRegistered<JSearchController>()) {
//       JSearchController.to.sendQuery();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController teCtl = TextEditingController();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Stack(
//           children: [
//             Card(
//               child: Form(
//                 child: TextFormField(
//                   keyboardType: TextInputType.text,
//                   controller: teCtl,
//                   onEditingComplete: () {
//                     search(teCtl.text);
//                   },
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontFamily: AppFonts.japaneseFont,
//                   ),
//                   decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     hintText: ' 일본어/한자/문법 검색...',
//                     hintStyle: TextStyle(fontSize: Responsive.height14),
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned.fill(
//               right: 10,
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       color: AppColors.mainBordColor,
//                       child: InkWell(
//                         onTap: () async {
//                           search(teCtl.text);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.all(Responsive.height10 / 2),
//                           child: Icon(
//                             Icons.search,
//                             size: Responsive.height30,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

class NewSearchWidget extends GetView<JSearchController> {
  const NewSearchWidget({super.key, required this.isHomeScreen});
  final bool isHomeScreen;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      void search() {
        controller.sendQuery();
        if (controller.teCnt.text.isNotEmpty && isHomeScreen) {
          Get.to(() => SearchScreen());
        }
      }

      return Padding(
        // padding: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.only(top: 10, bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Card(
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      readOnly: controller.isLoading.value,
                      controller: controller.teCnt,
                      onEditingComplete: () {
                        search();
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.japaneseFont,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: ' 일본어/한자/문법 검색...',
                        hintStyle: TextStyle(fontSize: Responsive.height14),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  right: 10,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          color:
                              controller.isLoading.value
                                  ? Colors.grey.shade300
                                  : AppColors.mainBordColor,
                          child: InkWell(
                            onTap: () async => search(),
                            child: Padding(
                              padding: EdgeInsets.all(Responsive.height10 / 2),
                              child: Icon(
                                Icons.search,
                                size: Responsive.height30,
                                color:
                                    controller.isLoading.value
                                        ? Colors.grey.shade100
                                        : Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
    // return GetBuilder<JSearchController>(
    //   builder: (userController) {
    //     void search() {
    //       userController.sendQuery();
    //       if (isHomeScreen) {
    //         Get.to(() => SearchScreen());
    //       }
    //     }

    //     return Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Stack(
    //             children: [
    //               Card(
    //                 child: Form(
    //                   child: TextFormField(
    //                     keyboardType: TextInputType.text,
    //                     readOnly: userController.isLoading.value,
    //                     controller: userController.teCnt,
    //                     onEditingComplete: () {
    //                       search();
    //                     },
    //                     style: const TextStyle(
    //                       fontWeight: FontWeight.w600,
    //                       fontFamily: AppFonts.japaneseFont,
    //                     ),
    //                     decoration: InputDecoration(
    //                       fillColor: Colors.white,
    //                       hintText: ' 일본어/한자/문법 검색...',
    //                       hintStyle: TextStyle(fontSize: Responsive.height14),
    //                       filled: true,
    //                       border: OutlineInputBorder(
    //                         borderSide: BorderSide.none,
    //                         borderRadius: BorderRadius.circular(15),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Positioned.fill(
    //                 right: 10,
    //                 child: Align(
    //                   alignment: Alignment.centerRight,
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       Card(
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(6),
    //                         ),
    //                         color:
    //                             userController.isLoading.value
    //                                 ? Colors.grey.shade300
    //                                 : AppColors.mainBordColor,
    //                         child: InkWell(
    //                           onTap: () async => search(),
    //                           child: Padding(
    //                             padding: EdgeInsets.all(
    //                               Responsive.height10 / 2,
    //                             ),
    //                             child: Icon(
    //                               Icons.search,
    //                               size: Responsive.height30,
    //                               color:
    //                                   userController.isLoading.value
    //                                       ? Colors.grey.shade100
    //                                       : Colors.white70,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
