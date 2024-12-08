import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/lock_model.dart';

class HomeController extends GetxController {
  Rx<LockModel?> currentLock = Rx<LockModel?>(null);

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController lockIdController = TextEditingController();

  // User info
  final String name = "John Doe";  // Example name, you can replace with dynamic data if needed
  final String email = "johndoe@example.com";  // Example email, you can replace with dynamic data if needed

  // Colors for lock status
  final Map<String, Color> statusColors = {
    "Locked": Colors.green,
    "Opened": Colors.blue,
    "Tampered": Colors.red,
    "Not Connected": Colors.grey,
  };

  // Connect a lock
  void connectLock() {
    String nickname = nicknameController.text.trim();
    String lockId = lockIdController.text.trim();

    if (nickname.isNotEmpty && lockId.isNotEmpty) {
      currentLock.value = LockModel(lockId: lockId, nickname: nickname);
      currentLock.value!.updateStatus("Locked"); // Default status
      Get.snackbar(
        "Connected",
        "Successfully connected to $nickname!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Please fill in both fields.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Logout functionality
  void logout() {
    currentLock.value = null;
    Get.snackbar(
      "Logged Out",
      "You have successfully logged out.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
