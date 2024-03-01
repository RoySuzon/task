import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:task/Controllers/api_controller.dart';
import 'package:task/Screens/Home/home_screen.dart';
import 'package:task/models/user_info.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      // appBar: AppBar(
      //   title: const Text('Login Screen'),
      // ),
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
              decoration: InputDecoration(
                  hintText: 'UserName', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Password', border: OutlineInputBorder()),

              // obscuringCharacter: '*',
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 16),
            MaterialButton(
              minWidth: double.infinity,
              height: 50,
              color: Colors.green,
              onPressed: () async {
                if (_userNameController.text.trim().isNotEmpty &&
                    _passwordController.text.trim().isNotEmpty) {
                  await ApiController()
                      .loginApi(
                          userName: _userNameController.text.toString().trim(),
                          passWord: _passwordController.text.toString().trim())
                      .then((value) async {
                    await Hive.box('userInfo').put('userInfo', value);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  });
                } else {
                  print('error');
                }
              },
              child: Text('Sign In'),
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
