import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:smart_gaurd/view/homescreen.dart';
import 'package:smart_gaurd/view/loginscreen.dart';
import 'package:smart_gaurd/view/signupscreen.dart';
import 'package:smart_gaurd/view/video_player.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the refresh token exists
  final String? refreshToken = await storage.read(key: 'refreshToken');

  runApp(MyApp(initialRoute: refreshToken != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/home', page: () => Homescreen()),
        GetPage(name: '/videoplayer', page: () => Video_Player(0)),
      ],
    );
  }
}
