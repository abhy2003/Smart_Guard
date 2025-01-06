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
        name: nicknameController.text.trim(),
        connection_id: 29829,
        lockStatus: 'Not Connected'.obs,
        tamperingValue: bool.fromEnvironment('yes'),
        motion: 0.0.obs,
        vibration: 0.0.obs,
      );
      locks.add(newLock);
      nicknameController.clear();
      lockIdController.clear();
    } else {
      Get.snackbar("Error", "Please fill in all fields.");
    }
  }


  void updateLockStatus(String lockId, String status,  bool tampering, double sensor) {
    final lock = locks.firstWhereOrNull((lock) => lock.connection_id == lockId);
    if (lock != null) {
      lock.lockStatus.value = status;
      lock.tamperingValue = tampering;
      lock.motion.value = sensor;
      locks.refresh();
    }
  }

  // Update the selected lock's details
  void updateSelectedLock(String status, bool tampering, double sensor) {
    if (selectedLock.value != null) {
      selectedLock.value!.lockStatus.value = status;
      selectedLock.value!.tamperingValue = tampering;
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
