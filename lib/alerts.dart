import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlert {
  // Error Alert
  static SnackbarController error(String title, String subtitle) {
    Get.closeAllSnackbars();
   return Get.snackbar(
      title, // Use the title passed to the method
      subtitle, // Use the subtitle passed to the method
      icon: Icon(Icons.warning, color: Colors.white), // Add a warning icon
      snackPosition: SnackPosition.TOP, // Position at the top
      backgroundColor: Colors.redAccent, // Set a background color
      colorText: Colors.white, // Set text color to white
      borderRadius: 10, // Add rounded corners
      margin: EdgeInsets.all(10), // Add some margin
      duration: Duration(seconds: 1), // Set duration
      isDismissible: true, // Allow user to dismiss it
      forwardAnimationCurve: Curves.easeOutBack, // Customize animation
    );
  }

  // Success Alert
  static SnackbarController success(String title, String subtitle) {
    Get.closeAllSnackbars();
   return Get.snackbar(
      title, // Use the title passed to the method
      subtitle, // Use the subtitle passed to the method
      icon: Icon(Icons.check_circle, color: Colors.white), // Add a success icon
      snackPosition: SnackPosition.TOP, // Position at the top
      backgroundColor: Colors.green, // Set a green background color
      colorText: Colors.white, // Set text color to white
      borderRadius: 10, // Add rounded corners
      margin: EdgeInsets.all(10), // Add some margin
      duration: Duration(seconds: 1), // Set duration
      isDismissible: true, // Allow user to dismiss it
      forwardAnimationCurve: Curves.easeOutBack, // Customize animation
    );
  }
}
