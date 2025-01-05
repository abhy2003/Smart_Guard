import 'package:get/get.dart';

class HomeScreenModel {
  String nickname;
  String lockId;
  RxString lockStatus;
  RxString tamperingValue;
  RxString sensorvalue;
  var isBluetoothConnected = false.obs;
  var isWiFiConnected = false.obs;

  HomeScreenModel({
    required this.nickname,
    required this.lockId,
    required this.lockStatus,
    required this.tamperingValue,
    required this.sensorvalue,
  });
}
