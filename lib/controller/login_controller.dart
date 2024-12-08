import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  final LoginModel loginModel = LoginModel();

  // Email and password controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Handle login
  void login() {
    String? emailError = loginModel.validateEmail(emailController.text);
    String? passwordError = loginModel.validatePassword(passwordController.text);

    if (emailError == null && passwordError == null) {
      // Logic for successful login
      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.toNamed('/home');
    } else {
      // Show validation errors
      Get.snackbar(
        'Error',
        emailError ?? passwordError!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Navigate to Sign Up
  void navigateToSignUp() {
    Get.toNamed('/signup');
  }
}
