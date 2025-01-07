import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/homescreen_model.dart';

class HomeController extends GetxController {

  final baseURL = 'http://192.168.1.2:8000/api';

  RxString username = "John Doe".obs;
  RxString email = "johndoe@example.com".obs;

  var locks = <HomeScreenModel>[].obs;
  var selectedLock = Rxn<HomeScreenModel>();

  final nicknameController = TextEditingController();
  final lockIdController = TextEditingController();
  bool lockfound=true;

  Map<String, Color> statusColors = {
    "Connected": Colors.green,
    "Disconnected": Colors.red,
    "Not Connected": Colors.grey,
  };

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user data when HomeScreen loads
  }

  void connectLock() {
    if (nicknameController.text.isNotEmpty && lockIdController.text.isNotEmpty) {
      final newLock = HomeScreenModel(
        id: 1,
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


  Future<void> updateLockStatus() async {
    final url = Uri.parse('http://192.168.1.2:8000/api/lock/lockstatusupdate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "id":"1",
          "status":"Open"
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        print('Changed Status:');
      } else {
        print('Failed to change status');
      }
    } catch (e) {
      print('Error: $e');
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

  Future<void> fetchUserData() async {
    final storage = FlutterSecureStorage();

    final String? accessToken = await storage.read(key: 'accessToken');
    final String? refreshToken = await storage.read(key: 'refreshToken');

    String id = 'null';
    String exp = 'null';

    if (refreshToken != null) {
      try {
        final payload = parseJwt(refreshToken);
        print('Payload: $payload');

        // Access specific data
        id = '${payload['user_id']}';
        exp = '${payload['exp']}';
      } catch (e) {
        print('Error parsing token: $e');
      }

      final userUrl = Uri.parse(baseURL+'/user/'+id);

      try {
        final response = await http.get(
          userUrl,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print('User Data Fetched');
          // Extract User Data
          username.value = responseData['username'];
          email.value = responseData['email'];
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> logout() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    print('Tokens removed successfully.');
    Get.toNamed('/login');
  }
}


Map<String, dynamic> parseJwt(String token) {
  // Split the token into parts
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid token');
  }

  // Decode the payload (second part of the token)
  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  final decodedBytes = base64Url.decode(normalized);
  final payloadMap = json.decode(utf8.decode(decodedBytes)) as Map<String, dynamic>;

  return payloadMap;
}