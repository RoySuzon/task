import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('userInfo');
  // await box.clear();
  print(box.values.toList());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
