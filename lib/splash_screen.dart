import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task/Screens/Auth/login_screen.dart';
import 'package:task/Screens/Home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogin() {
    Box box = Hive.box('userInfo');
    if (box.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      isLogin()
          ? Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ))
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: myCircularPrograce(),
      ),
    );
  }
}

Widget myCircularPrograce({Color? color}) {
  return Center(
    child: CircularProgressIndicator(
      color: color ?? Colors.white,
    ),
  );
}
