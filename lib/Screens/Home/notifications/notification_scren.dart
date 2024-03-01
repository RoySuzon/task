// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:task/models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  final List<NotificationModel> notifications;
  const NotificationScreen({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.edit),
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) => Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    notifications[index].readStatus.toString() == 'Yes'
                        ? SizedBox(
                            width: 10,
                          )
                        : Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 10,
                          ),
                    Text(
                      notifications[index].title.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                    Expanded(
                      child: Text(
                        notifications[index].createdAt.toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  notifications[index].description.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        itemCount: notifications.length,
      ),
    );
  }
}
