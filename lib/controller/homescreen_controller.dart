import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/homescreen_model.dart';

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
      bool isLockFound = checkForLock();

      if (isLockFound) {
        final newLock = HomeScreenModel(
          nickname: nicknameController.text.trim(),
          lockId: lockIdController.text.trim(),
          lockStatus: 'Not Connected'.obs,
          tamperingValue: 'No'.obs,
          motion: 'N/A'.obs,
          vibration: 0.0.obs,
        );
        locks.add(newLock);

        Get.snackbar(
          "Success",
          "Lock found",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        nicknameController.clear();
        lockIdController.clear();
      } else {
        Get.snackbar(
          "Error",
          "Lock doesn't found",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please fill in all fields.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  bool checkForLock() {
    return nicknameController.text == "ValidNickname" &&
        lockIdController.text == "ValidLockID";
  }



  void updateLockStatus(String lockId, String status, String tampering, String sensor) {
    final lock = locks.firstWhereOrNull((lock) => lock.lockId == lockId);
    if (lock != null) {
      lock.lockStatus.value = status;
      lock.tamperingValue.value = tampering;
      lock.motion.value = sensor;
      locks.refresh();
    }
  }

  // Update the selected lock's details
  void updateSelectedLock(String status, String tampering, String sensor) {
    if (selectedLock.value != null) {
      selectedLock.value!.lockStatus.value = status;
      selectedLock.value!.tamperingValue.value = tampering;
      selectedLock.value!.motion.value = sensor;
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
  void logout(){

  }
}
