import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  final LoginModel loginModel = LoginModel();


  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  RxString name = "John Doe".obs;
  RxString email = "johndoe@example.com".obs;

  void login() {
    String? emailError = loginModel.validateEmail(emailController.text);
    String? passwordError = loginModel.validatePassword(passwordController.text);

    if (emailError == null && passwordError == null) {
      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.toNamed('/home');
    } else {
      Get.snackbar(
        'Error',
        emailError ?? passwordError ?? 'Unknown error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void navigateToSignUp() {
    Get.toNamed('/signup');
  }
}
