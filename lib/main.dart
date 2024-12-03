import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_gaurd/view/loginscreen.dart';
import 'package:smart_gaurd/view/signupscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
      ],
    );
  }
}
