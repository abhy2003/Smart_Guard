import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_gaurd/view/homescreen.dart';
import 'package:smart_gaurd/view/loginscreen.dart';
import 'package:smart_gaurd/view/signupscreen.dart';
import 'package:smart_gaurd/view/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/home', page: () => Homescreen(),),
        GetPage(name: '/vedioplayer', page:() =>  VideoPlayer_live()),
      ],
    );
  }
}
