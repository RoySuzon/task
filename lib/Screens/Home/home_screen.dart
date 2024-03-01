import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task/Controllers/api_controller.dart';
import 'package:task/Screens/Home/notifications/notification_scren.dart';
import 'package:task/Screens/Home/widgets/custome_tab_bar.dart';
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
    ApiController().getNotificationList().then((value) {
      // print(jsonDecode(value)['data']['results']);
      // print(value);
      notificationLength = jsonDecode(value)['data']['totalunread'].toString();
      // print(notificationLength);
      // notifications = notificationModelFromJson(
      //     jsonEncode(jsonDecode(value)['data']['results']));
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        // backgroundColor: Colors.red,
        actions: [
          FutureBuilder(
            future: ApiController().getNotificationList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _notifications(
                  jsonDecode(snapshot.data)['data']['totalunread'].toString(),
                );
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
          onPressed: () async {
            if (notificationLength != '') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()));
            }
            return;
          },
          icon: Icon(Icons.notifications),
        ),
        notification == ''
            ? SizedBox()
            : Positioned(
                right: 8,
                top: 2,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      notification,
                      style: TextStyle(
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
