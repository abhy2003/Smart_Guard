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
      final newLock = HomeScreenModel(
        nickname: nicknameController.text.trim(),
        lockId: lockIdController.text.trim(),
        lockStatus: 'Not Connected'.obs,
        tamperingValue: 'No'.obs,
        sensorvalue: 'N/A'.obs,
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
      lock.lockStatus.value = status;
      lock.tamperingValue.value = tampering;
      lock.sensorvalue.value = sensor;
      locks.refresh();
    }
  }

  // Update the selected lock's details
  void updateSelectedLock(String status, String tampering, String sensor) {
    if (selectedLock.value != null) {
      selectedLock.value!.lockStatus.value = status;
      selectedLock.value!.tamperingValue.value = tampering;
      selectedLock.value!.sensorvalue.value = sensor;
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
