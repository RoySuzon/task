

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task/Common/app_color.dart';
import 'package:task/Controllers/api_controller.dart';
import 'package:task/Screens/Auth/login_screen.dart';
import 'package:task/Screens/Home/notifications/final_Notification_screen.dart';
// import 'package:task/Screens/Home/notifications/notification_screen_prectice.dart';
import 'package:task/Screens/Home/widgets/custome_tab_bar.dart';
import 'package:task/models/notification_model.dart';
// import 'package:task/models/notification_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String notificationLength = '';
  // List<NotificationModel> notifications = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppColor.peachColor,
      
        onPressed: () async {
          var box = Hive.box('userInfo');

          await box.clear();

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context)=>const LoginScreen(),
              ),
              (route) => false);
        },
        child: const Icon(CupertinoIcons.delete),
      ),
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.red,
        actions: [
          FutureBuilder(
            future: ApiController().getNotificationList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _notifications(notificationLength =
                    notificationModelFromJson(snapshot.data)
                        .data!
                        .totalunread
                        .toString()
                        .toString());
              } else {
                return _notifications('');
              }
            },
          )
        ],
        title: const Text('Home Screen'),
      ),
      body: const CustomeTabBar(),
    );
  }

  Widget _notifications(String notification) {
    return Stack(
      children: [
        IconButton(
          disabledColor: Colors.red,
          onPressed: notificationLength == ''
              ? null
              : () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FinalNotificationScreen()));
                  // builder: (context) => const NotificationScreen()));
                },
          icon: const Icon(Icons.notifications),
        ),
        notification == ''
            ? const SizedBox()
            : Positioned(
                right: 8,
                top: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      notification,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                ))
      ],
    );
  }
}
