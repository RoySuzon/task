import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task/Screens/Home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
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
              smartDashesType: SmartDashesType.enabled,
              // obscuringCharacter: '*',
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {},
              onSubmitted: (text) {
                print('Submitted: $text');
              },
            ),
            SizedBox(height: 16),
            MaterialButton(
              minWidth: double.infinity,
              height: 50,
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
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
