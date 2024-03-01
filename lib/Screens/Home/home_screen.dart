import 'package:flutter/material.dart';
import 'package:task/Screens/Home/widgets/custome_tab_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
        title: const Text('Home Screen'),
      ),
      body: const CustomeTabBar(),
    );
  }
}
