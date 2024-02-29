import 'package:flutter/material.dart';
import 'package:task/Screens/Home/widgets/custome_tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: CustomeTabBar(),
    );
  }
}
