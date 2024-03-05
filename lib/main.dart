import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/Common/app_color.dart';
// import 'package:task/Screens/Home/notifications/final_Notification_screen.dart';

import 'package:task/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
   await Hive.openBox('userInfo');
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
      title: 'Task',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.mainColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.textColor,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: AppColor.mainColor,shadowColor: Colors.white),
        useMaterial3: false,
      ),
      home:  const SplashScreen(),
    );
  }
}
