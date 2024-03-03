import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/Screens/Auth/login_screen.dart';
import 'package:task/Screens/Home/notifications/notification_screen_prectice.dart';
import 'package:task/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('userInfo');
  // await box.clear();
  // print(box.values.toList());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // scaffoldBackgroundColor: Color(0xFF226168),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
        useMaterial3: false,
      ),
      home:  SplashScreen(),
    );
  }
}
