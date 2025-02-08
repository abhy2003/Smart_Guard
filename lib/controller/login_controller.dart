import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  final LoginModel loginModel = LoginModel();


  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final storage = FlutterSecureStorage();
  final baseURL = 'http://3.109.91.102/api';

  Future<void> login() async {
    final loginUrl = Uri.parse(baseURL+'/login/');

    try {
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "username":usernameController.text,
          "password":passwordController.text
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Extract tokens
        final String refreshToken = responseData['refresh'];
        final String accessToken = responseData['access'];

        // Save tokens securely
        await storage.write(key: 'refreshToken', value: refreshToken);
          await storage.write(key: 'accessToken', value: accessToken);
        print(accessToken);

        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print('Login Successful');
        Get.toNamed('/home');
      } else {
        Get.snackbar(
          'Error',
          'Invalid Credentials',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Invalid Credentials');
      }
    } catch (e) {
      print('Error: $e');
    }


  }

  void navigateToSignUp() {
    Get.toNamed('/signup');
  }
}
