class LockModel {
  String lockId;
  String nickname;
  String lockStatus;
  String tamperingValue;
  String acclamationValue;

  LockModel({
    required this.lockId,
    required this.nickname,
    this.lockStatus = "Not Connected",
    this.tamperingValue = "83.0", // Default value for tampering status
    this.acclamationValue = "23.3", // Default value for acclamation status
  });

  // Update lock status
  void updateStatus(String status) {
    lockStatus = status;
  }

  void updateTamperingStatus(String tampering) {
    tamperingValue = tampering;
  }


  void updateAcclamationStatus(String acclamation) {
    acclamationValue = acclamation;
  }
}
