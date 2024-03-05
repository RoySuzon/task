// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:task/Common/app_color.dart';
import 'package:task/Controllers/api_controller.dart';
import 'package:task/Screens/Home/home_screen.dart';
import 'package:task/Screens/Home/notifications/notification_scren.dart';
import 'package:task/models/user_info.dart';
import 'package:task/splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _userNameController = TextEditingController(text: '0187832241');
  final _passwordController = TextEditingController(text: '123456');

  Future isLogin(String userName, String passWord) async {
    final data =
        await ApiController().loginApi(userName: userName, passWord: passWord);
    final user = userInfoFromJson(data);
    if (user.status == "200") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('L O G I N'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: SvgPicture.asset(
                'assets/undraw_mobile_login_re_9ntv.svg',
                height: 150,
                width: 150,
              ),
            ),

            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(
                  hintText: 'UserName', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'Password', border: OutlineInputBorder()),

              // obscuringCharacter: '*',
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16),
            MaterialButton(
              minWidth: double.infinity,
              height: 50,
              color: Colors.black,
              onPressed: () async {
                if (_userNameController.text.trim().isNotEmpty &&
                    _passwordController.text.trim().isNotEmpty) {
                  loading = true;
                  setState(() {});
                  await ApiController()
                      .loginApi(
                          userName: _userNameController.text.toString().trim(),
                          passWord: _passwordController.text.toString().trim())
                      .then((value) async {
                    if (jsonDecode(value)['status'] == "200") {
                      await Hive.box('userInfo').put('userInfo', value);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                          getToast(userInfoFromJson(value).message.toString());
                    } else {
                      loading = false;
                      getToast(jsonDecode(value)['message'].toString(),color: Colors.red);
                      setState(() {});
                      return;
                    }
                  });
                } else {
                  getToast('Please check password or UserName',color: Colors.red);
                  if (kDebugMode) {
                    print('error');
                  }
                }
              },
              child: loading
                  ? myCircularPrograce()
                  : const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            // Expanded(
            //     child: ListView.builder(
            //   itemBuilder: (context, index) {},
            // )),
          ],
        ),
      ),
    );
  }
}
