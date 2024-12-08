// sign_up_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/signup_model.dart';

class SignUpController extends GetxController {
  final _signUpModel = SignUpModel(lockId: '', email: '', password: '').obs;

  SignUpModel get signUpModel => _signUpModel.value;

  set lockId(String value) {
    _signUpModel.update((model) {
      model?.lockId = value;
    });
  }

  set email(String value) {
    _signUpModel.update((model) {
      model?.email = value;
    });
  }

  set password(String value) {
    _signUpModel.update((model) {
      model?.password = value;
    });
  }

  // Validate the form
  String? validateForm() {
    final lockIdError = signUpModel.validateLockId();
    if (lockIdError != null) return lockIdError;

    final emailError = signUpModel.validateEmail();
    if (emailError != null) return emailError;

    final passwordError = signUpModel.validatePassword();
    if (passwordError != null) return passwordError;

    return null; // No errors
  }

  // Handle sign up logic
  void signUp() {
    final errorMessage = validateForm();
    if (errorMessage != null) {
      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } else {
      Get.snackbar('Sign Up Attempt', 'Attempting to sign up...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      // Proceed with sign-up action (e.g., save to Firebase)
      Get.toNamed('/');
    }
  }
}
