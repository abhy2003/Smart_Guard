import 'package:get/get.dart';

class LockModel {
  int id;
  String name;
  RxString lockStatus;
  RxString tiltAlert = "NA".obs;
  RxString vibrationAlert = "NA".obs;
  RxString tampering = "NA".obs;

  LockModel({
    required this.id,
    required this.name,
    required this.lockStatus,
  });
}
