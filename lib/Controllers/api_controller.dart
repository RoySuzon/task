import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:task/models/user_info.dart';

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
    return {"Authorization": "Bearer $token"};
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
      jsonDecode(res.body)['status'] == "200";
      return res.body;
    } catch (e) {
      return jsonEncode({
        "status": '404',
        "message": 'Link is not Vailid',
        "data": {"totalunread": ''}
      });
    }
  }
}
