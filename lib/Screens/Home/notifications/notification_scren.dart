// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task/Controllers/api_controller.dart';
import 'package:task/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> tempNotification = [];
  bool loading = false;
  bool bottomCircular = false;
  int pageSize = 15;

  getNotification(int page) async {
    loading = true;
    setState(() {});
    await ApiController()
        .getNotificationList(page: page, pageSize: pageSize)
        .then((value) {
      for (var item in notificationModelFromJson(
          jsonEncode(jsonDecode(value)['data']['results']))) {
        tempNotification.add(item);
      }
    });
    loading = false;
    setState(() {});
  }

  getNextNotification(int page) async {
    bottomCircular = true;
    setState(() {});
    await ApiController()
        .getNotificationList(page: page, pageSize: pageSize)
        .then((value) {
      for (var item in notificationModelFromJson(
          jsonEncode(jsonDecode(value)['data']['results']))) {
        tempNotification.add(item);
      }
      if (notificationModelFromJson(
              jsonEncode(jsonDecode(value)['data']['results']))
          .isEmpty) {
        getToast('"This is Center Short Toast"');
      }
    });
    bottomCircular = false;
    setState(() {});
  }

  int page = 1;
  @override
  void initState() {
    getNotification(page);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Notifications'),
          actions: [
            GestureDetector(
              onTap: () {
                page++;
                getNextNotification(page);
                setState(() {});
              },
              child: const Icon(Icons.edit),
            ),
            const SizedBox(width: 16)
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text((index + 1).toString()),
                                  tempNotification[index]
                                              .readStatus
                                              .toString() ==
                                          'Yes'
                                      ? SizedBox(
                                          width: 10,
                                        )
                                      : Icon(
                                          Icons.circle,
                                          color: Colors.red,
                                          size: 10,
                                        ),
                                  Text(
                                    tempNotification[index].title.toString(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Expanded(
                                    child: Text(
                                      tempNotification[index]
                                          .createdAt
                                          .toString(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                tempNotification[index].description.toString(),
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      itemCount: tempNotification.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 0,
                          thickness: 2,
                          // endIndent: 100,
                          // indent: 100,
                          color: Colors.white,
                        );
                      },
                    ),
            ),
            bottomCircular
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.white, color: Colors.red)),
                  )
                : SizedBox()
          ],
        )

        // FutureBuilder(
        //   future: ApiController().getNotificationList(page: page, pageSize: 5),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       for (var item in notificationModelFromJson(
        //           jsonEncode(jsonDecode(snapshot.data)['data']['results']))) {
        //         tempNotification.add(item);
        //       }
        //       if (tempNotification.isNotEmpty) {
        //         notificationModelFromJson(
        //                 jsonEncode(jsonDecode(snapshot.data)['data']['results']))
        //             .clear();
        //       }
        //       return ListView.builder(
        //         shrinkWrap: true,
        //         padding: EdgeInsets.zero,
        //         itemBuilder: (context, index) => Card(
        //           color: Colors.white,
        //           child: Padding(
        //             padding: const EdgeInsets.all(12.0),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Row(
        //                   children: [
        //                     Text((index + 1).toString()),
        //                     tempNotification[index].readStatus.toString() == 'Yes'
        //                         ? SizedBox(
        //                             width: 10,
        //                           )
        //                         : Icon(
        //                             Icons.circle,
        //                             color: Colors.red,
        //                             size: 10,
        //                           ),
        //                     Text(
        //                       tempNotification[index].title.toString(),
        //                       style: TextStyle(color: Colors.red),
        //                     ),
        //                     Expanded(
        //                       child: Text(
        //                         tempNotification[index].createdAt.toString(),
        //                         textAlign: TextAlign.end,
        //                         style: TextStyle(color: Colors.red),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 SizedBox(height: 15),
        //                 Text(
        //                   tempNotification[index].description.toString(),
        //                   textAlign: TextAlign.end,
        //                   style: TextStyle(color: Colors.red),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         itemCount: tempNotification.length,
        //       );
        //     } else if (mounted) {
        //       return Center(
        //           child: CircularProgressIndicator(
        //         color: Colors.white,
        //       ));
        //     }
        //     return Center(
        //         child: CircularProgressIndicator(
        //       color: Colors.white,
        //     ));
        //   },
        // ),

        );
  }
}

getToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
