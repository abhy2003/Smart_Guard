import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/lock_model.dart';

class HomeController extends GetxController {
  Rx<LockModel?> currentLock = Rx<LockModel?>(null);

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController lockIdController = TextEditingController();

  // User info
  final String name = "John Doe";  // Example name, replace with dynamic data if needed
  final String email = "johndoe@example.com";  // Example email, replace with dynamic data if needed

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
      currentLock.value = LockModel(
        lockId: lockId,
        nickname: nickname,
      );
      currentLock.value!.updateStatus("Locked"); // Default status for lock
      currentLock.value!.updateTamperingStatus("No Tampering"); // Default tampering status
      currentLock.value!.updateAcclamationStatus("Not Acclaimed"); // Default acclamation status

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

  // Update tampering status
  void updateTamperingStatus(String status) {
    if (currentLock.value != null) {
      currentLock.value!.updateTamperingStatus(status);
      Get.snackbar(
        "Tampering Status Updated",
        "Tampering status updated to: $status",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    }
  }

  // Update acclamation status
  void updateAcclamationStatus(String status) {
    if (currentLock.value != null) {
      currentLock.value!.updateAcclamationStatus(status);
      Get.snackbar(
        "Acclamation Status Updated",
        "Acclamation status updated to: $status",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
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
