import 'package:get/get.dart';

class HomeScreenModel {
  int id;
  String name;
  int connection_id;
  RxString lockStatus;
  bool tamperingValue;
  RxDouble motion;
  RxDouble vibration;
  var isBluetoothConnected = false.obs;
  var isWiFiConnected = false.obs;
  var isBluetoothLoading = false.obs;
  var isWiFiLoading = false.obs;
  var isBluetoothAnimationShown = false.obs;
  var isWiFiAnimationShown = false.obs;
  HomeScreenModel({
    required this.id,
    required this.name,
    required this.connection_id,
    required this.lockStatus,
    required this.tamperingValue,
    required this.motion,
    required this.vibration,
  });
}
