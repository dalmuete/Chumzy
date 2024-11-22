// import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
// import 'package:chumzy/data/providers/flashcard_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:provider/provider.dart';

// void explainModal({
//   required BuildContext context,
//   required Function setState,
//   required String term,
//   required String definition,
// }) {
//   var explainController = TextEditingController();
//   final ScrollController scrollController = ScrollController();

//   showModalBottomSheet(
//     useSafeArea: true,
//     showDragHandle: false,
//     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     enableDrag: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
//     ),
//     elevation: 1,
//     isScrollControlled: true,
//     context: context,
//     builder: (context) {
     
//       return StatefulBuilder(
//         builder: (BuildContext context, innerSetState) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (scrollController.hasClients) {
//               scrollController.animateTo(
//                 scrollController.position.maxScrollExtent,
//                 duration: Duration(milliseconds: 300),
//                 curve: Curves.easeOut,
//               );
//             }
//           });

//           return GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: Padding(
//                 padding: EdgeInsets.only(
//                     top: 10.r, bottom: 20.r, left: 24.r, right: 20.r),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         height: 5.h,
//                         width: 100.w,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .secondary
//                               .withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         margin: EdgeInsets.symmetric(vertical: 8),
//                       ),
//                     ),
//                     Gap(10.h),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Theme.of(context)
//                               .colorScheme
//                               .secondary
//                               .withOpacity(0.5),
//                           backgroundImage: AssetImage(
//                               'assets/chumzy_character/chumzy_icon.png'),
//                           radius: 20.r,
//                         ),
//                         Gap(20.w),
//                         Text(
//                           "Chumzy AI",
//                           style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Gap(30.h),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         controller: scrollController,
//                         child: Column(
//                           children: [
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundColor: Theme.of(context)
//                                         .colorScheme
//                                         .secondary
//                                         .withOpacity(0.5),
//                                     backgroundImage: AssetImage(
//                                         'assets/chumzy_character/chumzy_icon.png'),
//                                     radius: 20.r,
//                                   ),
//                                   Gap(10.w),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width *
//                                         0.75,
//                                     padding: EdgeInsets.all(20.r),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Theme.of(context)
//                                               .primaryColor
//                                               .withOpacity(0.5)),
//                                       borderRadius: BorderRadius.circular(20.r),
//                                     ),
//                                     child: Center(
//                                       child: Text(response),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Gap(20.h),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Padding(
//                     //   padding: EdgeInsets.only(
//                     //       bottom: MediaQuery.of(context).viewInsets.bottom),
//                     //   child: Column(
//                     //     children: [
//                     //       Gap(20.h),
//                     //       Row(
//                     //         children: [
//                     //           Expanded(
//                     //             child: CustomBorderTextField(
//                     //               hintText:
//                     //                   "Ask for more details or clarification",
//                     //               controller: explainController,
//                     //             ),
//                     //           ),
//                     //           Gap(10.w),
//                     //           IconButton(
//                     //             onPressed: () {},
//                     //             icon: Icon(Icons.send_rounded),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 )),
//           );
//         },
//       );
//     },
//   ).whenComplete(() {
//     scrollController.dispose();
//   });
// }
