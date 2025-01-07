import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../model/signup_model.dart';

class SignUpController extends GetxController {
  final _signUpModel = SignUpModel(username: '', email: '', password: '').obs;

  final storage = FlutterSecureStorage();
  final baseURL = 'http://192.168.1.2:8000/api';

  SignUpModel get signUpModel => _signUpModel.value;

  set username(String value) {
    _signUpModel.update((model) {
      model?.username = value;
      model?.validateUserName();
    });
  }

  set email(String value) {
    _signUpModel.update((model) {
      model?.email = value;
      model?.validateEmail();
    });
  }

  set password(String value) {
    _signUpModel.update((model) {
      model?.password = value;
      model?.validatePassword();
    });
  }

  // Handle sign-up logic
  Future<void> signUp() async {
    _signUpModel.update((model) {
      model?.validateUserName();
      model?.validateEmail();
      model?.validatePassword();
    });

    if (signUpModel.isValid) {
      final signupUrl = Uri.parse(baseURL+'/signup/');

      try {
        final response = await http.post(
          signupUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "username":'${signUpModel.username}',
            "email":'${signUpModel.email}',
            "password":'${signUpModel.password}'
          }),
        );

        if (response.statusCode == 201) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          // Extract tokens
          final String refreshToken = responseData['refresh'];
          final String accessToken = responseData['access'];

          // Save tokens securely
          await storage.write(key: 'refreshToken', value: refreshToken);
          await storage.write(key: 'accessToken', value: accessToken);
          print(accessToken);

          Get.snackbar(
            'Sign Up Success',
            'Attempting to sign up...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          print('Signup Successful');
          Get.toNamed('/home');
        } else {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final String error = '${responseData['non_field_errors'][0]}';
          Get.snackbar(
            'Error',
            error,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          print('Bad Request');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      Get.snackbar(
        'Error',
        'Please fix the errors before submitting.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}