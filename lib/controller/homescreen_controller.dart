import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../model/lock_model.dart';

class LockController extends GetxController {
  final baseURL = 'http://3.109.91.102/api';

  RxString username = "John Doe".obs;
  RxString email = "johndoe@example.com".obs;

  var locks = <LockModel>[].obs;
  var selectedLock = Rxn<LockModel>();

  final nameController = TextEditingController();
  final lockIdController = TextEditingController();
  bool lockfound = true;

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user details
    fetchUserLocks(); // Fetch locks the user has access to
    startSensorUpdates();
  }

  /// Fetches the user's lock access and loads lock details.
  Future<void> fetchUserLocks() async {
    final storage = FlutterSecureStorage();
    final String? accessToken = await storage.read(key: 'accessToken');
    final String? refreshToken = await storage.read(key: 'refreshToken');

    if (accessToken == null || refreshToken == null) {
      print("No access token or refresh token found.");
      return;
    }

    // Extract user ID from JWT token
    String userId = 'null';
    try {
      final payload = parseJwt(refreshToken);
      userId = '${payload['user_id']}';
    } catch (e) {
      print('Error parsing token: $e');
      return;
    }

    final url = Uri.parse('$baseURL/Userlockaccess/');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> accessList = json.decode(response.body);

        // Filter locks that belong to the logged-in user
        final userLocks = accessList.where((access) => access['user'].toString() == userId).toList();

        if (userLocks.isNotEmpty) {
          for (var access in userLocks) {
            final int lockId = access['lock'];
            await fetchLockDetails(lockId);
          }
          print("User locks fetched successfully.");
        } else {
          print("No locks found for user ID: $userId");
        }
      } else {
        print("Failed to fetch user lock access.");
      }
    } catch (e) {
      print("Error fetching user locks: $e");
    }
  }


  /// Fetches details for a specific lock by its ID.
  Future<void> fetchLockDetails(int lockId) async {
    final url = Uri.parse('$baseURL/lock/$lockId/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> lockData = json.decode(response.body);

        final newLock = LockModel(
          id: lockData['id'],
          name: lockData['name'],
          lockStatus: RxString(lockData['status']),
        );

        locks.add(newLock);
      } else {
        print("Failed to fetch lock details for lock ID: $lockId");
      }
    } catch (e) {
      print("Error fetching lock details: $e");
    }
  }

  /// Fetches user details from the API.
  Future<void> fetchUserData() async {
    final storage = FlutterSecureStorage();
    final String? refreshToken = await storage.read(key: 'refreshToken');

    if (refreshToken == null) {
      print("No refresh token found.");
      return;
    }

    String id = 'null';

    try {
      final payload = parseJwt(refreshToken);
      id = '${payload['user_id']}';
    } catch (e) {
      print('Error parsing token: $e');
      return;
    }

    final userUrl = Uri.parse('$baseURL/user/$id');

    try {
      final response = await http.get(
        userUrl,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        username.value = responseData['username'];
        email.value = responseData['email'];
        print('User data fetched.');
      } else {
        print('Failed to fetch user data.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Connects a lock manually by fetching its data.
  void connectLock() async {
    if (lockIdController.text.isNotEmpty) {
      final lockId = lockIdController.text.trim();
      final url = Uri.parse('$baseURL/lock/$lockId/');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final Map<String, dynamic> lockData = json.decode(response.body);

          final newLock = LockModel(
            id: lockData['id'],
            name: lockData['name'],
            lockStatus: RxString(lockData['status']),
          );

          locks.add(newLock);
          nameController.clear();
          lockIdController.clear();
          print("Lock connected successfully.");
        } else {
          Get.snackbar("Error", "Failed to fetch lock details.");
        }
      } catch (e) {
        Get.snackbar("Error", "An error occurred: $e");
        print(e);
      }
    } else {
      Get.snackbar("Error", "Please enter a Lock ID.");
    }
  }

  /// Updates the lock status in the backend.
  Future<void> updateLockStatus(String status,int id) async {
    final url = Uri.parse('$baseURL/lock/lockstatusupdate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "id": id,
          "status": status,
        }),
      );

      if (response.statusCode == 200) {
        print('Lock status updated.');
      } else {
        print('Failed to update lock status.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Selects a lock.
  void selectLock(LockModel lock) {
    selectedLock.value = lock;
  }

  /// Removes a lock from the list.
  void removeLock(LockModel lock) {
    locks.remove(lock);
    if (selectedLock.value == lock) {
      selectedLock.value = null;
    }
  }

  void startSensorUpdates() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      await fetchSensorData();
    });
  }

  Future<void> fetchSensorData() async {
    final url = Uri.parse('$baseURL/sensordata/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> sensorDataList = json.decode(response.body);

        for (var lock in locks) {
          // Get all sensor records for the current lock
          final lockSensorData = sensorDataList
              .where((data) => data['lock'] == lock.id)
              .toList();

          if (lockSensorData.isNotEmpty) {
            // Sort by timestamp (latest first)
            lockSensorData.sort((a, b) => DateTime.parse(b['timestamp'])
                .compareTo(DateTime.parse(a['timestamp'])));

            final latestSensorData = lockSensorData.first;
            print(latestSensorData);

            // Update tilt and vibration alerts
            lock.tiltAlert.value = latestSensorData['device_tilted'] ? "Tilt Detected" : "No Tilt";
            print(lock.tiltAlert.value);
            lock.vibrationAlert.value = latestSensorData['vibration_detected'] ? "Vibration Detected" : "No Vibration";
            lock.tampering.value = (latestSensorData['device_tilted'] || latestSensorData['vibration_detected']) ? "Tampering Detected" : "No Tampering";

            print("Updated sensor data for Lock ID: ${lock.id}");
          }
        }
      } else {
        print("Failed to fetch sensor data.");
      }
    } catch (e) {
      print("Error fetching sensor data: $e");
    }
  }

  /// Logs out the user and clears stored tokens.
  Future<void> logout() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    print('Tokens removed successfully.');
    Get.toNamed('/login');
  }

  /// Parses a JWT token and extracts the payload.
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decodedBytes = base64Url.decode(normalized);
    final payloadMap = json.decode(utf8.decode(decodedBytes)) as Map<String, dynamic>;

    return payloadMap;
  }
}
