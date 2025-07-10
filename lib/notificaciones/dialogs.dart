// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class Dialogs {
//   static Future<bool> showDialog(
//       String title, String content, DialogType type) async {
//     switch (type) {
//       case DialogType.info:
//         return _showInfo(title, content);
//       case DialogType.alert:
//         return _showAlert(title, content);
//       case DialogType.confirm:
//         return _showConfirm(title, content);
//       case DialogType.critical:
//         return _showCritical(title, content);
//     }
//   }

//   static Future<bool> _showInfo(String title, String content) async {
//     bool? response = await Get.dialog<bool>(Dialog(
//       backgroundColor: AppColors.blackColor,
//       surfaceTintColor: AppColors.blackColor,
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25.r),
//             border: Border.all(
//                 color: AppColors.whiteColor.withValues(alpha: .2), width: 1)),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25.r),
//           child: Container(
//             width: Get.width * .9,
//             padding: const EdgeInsets.all(18.0),
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.transparent,
//                 boxShadow: [
//                   BoxShadow(
//                       color: AppColors.dialogInfoColor.withValues(alpha: .4),
//                       blurRadius: 80.r,
//                       spreadRadius: 10.r)
//                 ]),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FaIcon(
//                   TablerIcons.info_circle,
//                   color: AppColors.whiteColor,
//                 ),
//                 SizedBox(
//                   height: 8.h,
//                 ),
//                 Text(
//                   title,
//                   style: Theme.of(Get.context!)
//                       .textTheme
//                       .titleMedium!
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 12.h,
//                 ),
//                 Text(
//                   content,
//                 ),
//                 SizedBox(
//                   height: 24.h,
//                 ),
//                 CustomElevatedButton(
//                   onPressed: () =>
//                       Navigator.of(Get.context!, rootNavigator: false)
//                           .pop(true),
//                   label: "dialogs.buttons.accept".tr,
//                   size: ElevatedButtonSize.small,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));
//     return response ?? false;
//   }

//   static Future<bool> _showAlert(String title, String content) async {
//     bool? response = await Get.dialog<bool>(Dialog(
//       backgroundColor: AppColors.blackColor,
//       surfaceTintColor: AppColors.blackColor,
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25.r),
//             border: Border.all(
//                 color: AppColors.whiteColor.withValues(alpha: .2), width: 1)),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25.r),
//           child: Container(
//             width: Get.width * .9,
//             padding: const EdgeInsets.all(18.0),
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.transparent,
//                 boxShadow: [
//                   BoxShadow(
//                       color: AppColors.dialogWarningColor.withValues(alpha: .4),
//                       blurRadius: 80.r,
//                       spreadRadius: 10.r)
//                 ]),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FaIcon(
//                   TablerIcons.alert_triangle,
//                   color: AppColors.whiteColor,
//                 ),
//                 SizedBox(
//                   height: 8.h,
//                 ),
//                 Text(
//                   title,
//                   style: Theme.of(Get.context!)
//                       .textTheme
//                       .titleMedium!
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 12.h,
//                 ),
//                 Text(
//                   content,
//                 ),
//                 SizedBox(
//                   height: 24.h,
//                 ),
//                 CustomElevatedButton(
//                   onPressed: () =>
//                       Navigator.of(Get.context!, rootNavigator: false)
//                           .pop(true),
//                   label: "dialogs.buttons.accept".tr,
//                   size: ElevatedButtonSize.small,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));
//     return response ?? false;
//   }

//   static Future<bool> _showConfirm(String title, String content) async {
//     bool? response = await Get.dialog<bool>(Dialog(
//       backgroundColor: AppColors.blackColor,
//       surfaceTintColor: AppColors.blackColor,
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25.r),
//             border: Border.all(
//                 color: AppColors.whiteColor.withValues(alpha: .2), width: 1)),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25.r),
//           child: Container(
//             width: Get.width * .9,
//             padding: const EdgeInsets.all(18.0),
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.transparent,
//                 boxShadow: [
//                   BoxShadow(
//                       color: AppColors.dialogErrorColor.withValues(alpha: .4),
//                       blurRadius: 80.r,
//                       spreadRadius: 10.r)
//                 ]),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FaIcon(
//                   TablerIcons.hand_stop,
//                   color: AppColors.whiteColor,
//                 ),
//                 SizedBox(
//                   height: 8.h,
//                 ),
//                 Text(
//                   title,
//                   style: Theme.of(Get.context!)
//                       .textTheme
//                       .titleMedium!
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 12.h,
//                 ),
//                 Text(
//                   content,
//                 ),
//                 SizedBox(
//                   height: 24.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     CustomElevatedButton(
//                       onPressed: () =>
//                           Navigator.of(Get.context!, rootNavigator: false)
//                               .pop(true),
//                       label: "dialogs.buttons.accept".tr,
//                       size: ElevatedButtonSize.small,
//                     ),
//                     CustomElevatedButton(
//                       onPressed: () =>
//                           Navigator.of(Get.context!, rootNavigator: false)
//                               .pop(false),
//                       label: "dialogs.buttons.cancel".tr,
//                       filled: true,
//                       size: ElevatedButtonSize.small,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));
//     return response ?? false;
//   }

//   static Future<bool> _showCritical(String title, String content,
//       [Duration? waitTime]) async {
//     final Rxn<int> remainingTime = Rxn<int>(waitTime?.inSeconds ?? 15);
//     final timer = Timer.periodic(Duration(seconds: 1), (t) {
//       if (remainingTime.value == 0) {
//         t.cancel();
//         return;
//       }
//       remainingTime.value = remainingTime.value! - 1;
//     });
//     bool? response = await Get.dialog<bool>(Dialog(
//       backgroundColor: AppColors.blackColor,
//       surfaceTintColor: AppColors.blackColor,
//       child: StatefulBuilder(builder: (dialogContext, setDialogState) {
//         return Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25.r),
//               border: Border.all(
//                   color: AppColors.whiteColor.withValues(alpha: .2), width: 1)),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(25.r),
//             child: Container(
//               width: Get.width * .9,
//               padding: const EdgeInsets.all(18.0),
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.transparent,
//                   boxShadow: [
//                     BoxShadow(
//                         color: AppColors.dialogErrorColor.withValues(alpha: .4),
//                         blurRadius: 80.r,
//                         spreadRadius: 10.r)
//                   ]),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   FaIcon(
//                     TablerIcons.hand_stop,
//                     color: AppColors.whiteColor,
//                   ),
//                   SizedBox(
//                     height: 8.h,
//                   ),
//                   Text(
//                     title,
//                     style: Theme.of(Get.context!)
//                         .textTheme
//                         .titleMedium!
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 12.h,
//                   ),
//                   Text(
//                     content,
//                   ),
//                   SizedBox(
//                     height: 24.h,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Obx(() {
//                         return CustomElevatedButton(
//                           onPressed: remainingTime.value! > 0
//                               ? null
//                               : () => Navigator.of(Get.context!,
//                                       rootNavigator: false)
//                                   .pop(true),
//                           label:
//                               "($remainingTime)${"dialogs.buttons.accept".tr}",
//                           filled: true,
//                           size: ElevatedButtonSize.small,
//                         );
//                       }),
//                       CustomElevatedButton(
//                         onPressed: () =>
//                             Navigator.of(Get.context!, rootNavigator: false)
//                                 .pop(false),
//                         label: "dialogs.buttons.cancel".tr,
//                         size: ElevatedButtonSize.small,
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     ));

//     timer.cancel();
//     return response ?? false;
//   }
// }
