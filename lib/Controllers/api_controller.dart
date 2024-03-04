import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:task/models/user_info.dart';
 UserInfo getInfo()  {
    Box box = Hive.box('userInfo');
    // print(userInfoFromJson(box.get('userInfo')).data!.token.toString());
    return userInfoFromJson( box.get('userInfo'));
  }
class ApiController {
  final String baseUrl = 'http://sherpur.rbfgroupbd.com/';
//getToken From Hive
  Future<String> getToken() async {
    Box box = Hive.box('userInfo');
    // print(userInfoFromJson(box.get('userInfo')).data!.token.toString());
    return userInfoFromJson(box.get('userInfo')).data!.token.toString();
  }

// Get Headers
  Map<String, String> getHeader(String token) {
    return {"Authorization": "Bearer $token",'Content-Type': 'application/json'};
  }

//Login Api..
  Future<dynamic> loginApi(
      {required String userName, required String passWord}) async {
    final String url = '${baseUrl}login';
    log(url, name: 'Login Url');
    Map<String, String> loginBody = {
      "username": userName,
      "password": passWord
    };
    try {
      final res = await post(Uri.parse(url), body: loginBody);
      jsonDecode(res.body)['status'] == "200";
      return res.body;
    } catch (e) {
      return jsonEncode({"status": '404', "message": 'Link is not Vailid'});
    }
  }

//get Notifications Api

  Future<dynamic> getNotificationList({int? page, int? pageSize}) async {
    try {
      final res = await get(
          Uri.parse(
              "${baseUrl}get_notification?page=${page ?? ''}&pageSize=${pageSize ?? ''}"),
          headers: getHeader(await getToken()));
     
      return res.body;
    } catch (e) {
      return jsonEncode({
        "status": '404',
        "message": 'Link is not Vailid',
        "data": {"totalunread": ''}
      });
    }
  }

//mark as read api
  Future<dynamic> markAsReadApi(List<int> ids) async {
    final data = jsonEncode(ids.toString());
    print(data);
    try {
      final body = jsonEncode({
        "notification_Ids": ids,
        "status": "Read"
        // "status": "Delete"
      });
      print("$ids");
      final res = await post(Uri.parse("${baseUrl}update_notification_status"),
          headers: getHeader(await getToken()), body: body);
      // jsonDecode(res.body)['status'] == "200";
      log(res.body);
      return res.body;
    } catch (e) {
      print(e);
      return jsonEncode({
        "status": '404',
        "message": 'Link is not Vailid',
        "data": {"totalunread": ''}
      });
    }
  }

//Delete  api
  Future<dynamic> deleteApi(List<int> ids) async {
    final data = jsonEncode(ids.toString());
    print(data);
    try {
      final body = jsonEncode({
        "notification_Ids": ids,
        // "status": "Read"
        "status": "Delete"
      });
      print("$ids");
      final res = await post(Uri.parse("${baseUrl}update_notification_status"),
          headers: getHeader(await getToken()), body: body);
      // jsonDecode(res.body)['status'] == "200";
      log(res.body);
      return res.body;
    } catch (e) {
      print(e);
      return jsonEncode({
        "status": '404',
        "message": 'Link is not Vailid',
        "data": {"totalunread": ''}
      });
    }
  }
}



Body bodyFromJson(String str) => Body.fromJson(json.decode(str));

String bodyToJson(Body data) => json.encode(data.toJson());

class Body {
    final List<int>? notificationIds;
    final String? status;

    Body({
        this.notificationIds,
        this.status,
    });

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        notificationIds: json["notification_Ids"] == null ? [] : List<int>.from(json["notification_Ids"]!.map((x) => x)),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "notification_Ids": notificationIds == null ? [] : List<dynamic>.from(notificationIds!.map((x) => x)),
        "status": status,
    };
}
