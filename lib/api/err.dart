import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowErrors with ChangeNotifier {
  ShowErrors.internal();

  static showErrors(String message) async {
    return Get.showSnackbar(
      GetBar(
        title: null,
        message: message,
        isDismissible: true,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // static showErrors(String message) async {
  //   return Get.snackbar(
  //     '', '',
  //     snackbarStatus: (SnackbarStatus status) {
  //       print(status);
  //     },
  //     // leftBarIndicatorColor: Colors.black,
  //     margin: EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
  //     duration: Duration(seconds: 5),
  //     backgroundColor: Color(0xff2b2b2b),
  //     titleText: Text(
  //       'Failed to Process Request',
  //       style: GoogleFonts.workSans(
  //           color: Colors.white70, fontWeight: FontWeight.w500),
  //     ),
  //     messageText: Text(
  //       message,
  //       style: GoogleFonts.workSans(
  //         color: Colors.white70,
  //       ),
  //     ),
  //     snackPosition: SnackPosition.BOTTOM,
  //     snackStyle: SnackStyle.FLOATING,
  //     shouldIconPulse: true,
  //     icon: Icon(Icons.error, color: Colors.white60),
  //     isDismissible: true,
  //     borderRadius: 8,
  //     mainButton: TextButton(
  //       onPressed: () async {
  //         if (Get.isSnackbarOpen) {
  //           Get.back();
  //         }
  //       },
  //       child: Icon(
  //         Icons.close,
  //         color: Colors.white70,
  //       ),
  //     ),
  //   );
  // }

  static showToast(String message) async {
    return Get.showSnackbar(
      GetBar(
        title: null,
        message: message,
        isDismissible: true,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // static showToast(String message) async {
  //   return Get.snackbar(
  //     '', '',
  //     snackbarStatus: (SnackbarStatus status) {
  //       print(status);
  //     },
  //     // leftBarIndicatorColor: Colors.black,
  //     margin: EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
  //     duration: Duration(seconds: 5),
  //     // backgroundColor: Colors.,
  //     titleText: Text(
  //       'Failed to Process Request',
  //       style: GoogleFonts.workSans(
  //           color: Colors.white70, fontWeight: FontWeight.w500),
  //     ),
  //     messageText: Text(
  //       message,
  //       style: GoogleFonts.workSans(
  //         color: Colors.white70,
  //       ),
  //     ),
  //     snackPosition: SnackPosition.BOTTOM,
  //     snackStyle: SnackStyle.FLOATING,
  //     shouldIconPulse: true,
  //     icon: Icon(
  //       Icons.info,
  //       color: Colors.white60,
  //     ),
  //     isDismissible: true,
  //     borderRadius: 8,
  //     mainButton: TextButton(
  //       onPressed: () async {
  //         if (Get.isSnackbarOpen) {
  //           Get.back();
  //         }
  //       },
  //       child: Icon(
  //         Icons.close,
  //         color: Colors.white70,
  //       ),
  //     ),
  //   );
  // }
}
