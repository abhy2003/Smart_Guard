// models/home_screen_model.dart
class HomeScreenModel {
  String nickname;
  String lockId;
  String lockStatus;
  String? tamperingValue;
  String? sensorvalue;

  HomeScreenModel({
    required this.nickname,
    required this.lockId,
    this.lockStatus = "Not Connected",
    this.tamperingValue,
    this.sensorvalue,
  });
}
