class LockModel {
  String lockId;
  String nickname;
  String lockStatus;

  LockModel({
    required this.lockId,
    required this.nickname,
    this.lockStatus = "Not Connected",
  });

  // Update lock status
  void updateStatus(String status) {
    lockStatus = status;
  }
}
