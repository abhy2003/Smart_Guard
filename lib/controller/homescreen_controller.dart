// controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/lock_model.dart';

class HomeController extends GetxController {
  var locks = <HomeScreenModel>[].obs;
  var selectedLock = Rxn<HomeScreenModel>();

  final nicknameController = TextEditingController();
  final lockIdController = TextEditingController();

  Map<String, Color> statusColors = {
    "Connected": Colors.green,
    "Disconnected": Colors.red,
    "Not Connected": Colors.grey,
  };

  void connectLock() {
    if (nicknameController.text.isNotEmpty && lockIdController.text.isNotEmpty) {
      final newLock = HomeScreenModel(
        nickname: nicknameController.text.trim(),
        lockId: lockIdController.text.trim(),
        lockStatus: "Not Connected", // Default status
        tamperingValue: "No", // Default tampering value
        sensorvalue: "N/A", // Default sensor value
      );
      locks.add(newLock);
      nicknameController.clear();
      lockIdController.clear();
    } else {
      Get.snackbar("Error", "Please fill in all fields.");
    }
  }
  void updateLockStatus(String lockId, String status, String tampering, String sensor) {
    final lock = locks.firstWhereOrNull((lock) => lock.lockId == lockId);
    if (lock != null) {
      lock.lockStatus = status;
      lock.tamperingValue = tampering;
      lock.sensorvalue = sensor;
      locks.refresh(); // Refresh the observable list to update the UI
    }
  }
  void updateSelectedLock(String status, String tampering, String sensor) {
    if (selectedLock.value != null) {
      selectedLock.value!.lockStatus = status;
      selectedLock.value!.tamperingValue = tampering;
      selectedLock.value!.sensorvalue = sensor;
      selectedLock.refresh();
    }
  }


  void selectLock(HomeScreenModel lock) {
    selectedLock.value = lock;
  }

  void removeLock(HomeScreenModel lock) {
    locks.remove(lock);
    if (selectedLock.value == lock) {
      selectedLock.value = null;
    }
  }

  void logout() {
    // Add logout logic here
  }
}
