import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

class ApiController {
  final String baseUrl = 'http://sherpur.rbfgroupbd.com/';
  Map<String, String> getHeader(String token) {
    return {"Authorization": "Bearer $token"};
  }

  Future<dynamic> loginApi(
      {required String userName, required String passWord}) async {
    final String url = '${baseUrl}login';
    log(url, name: 'Login Url');
    Map<String, String> loginBody = {
      "username": userName,
      "password": passWord
    };
// print(body);

    try {
      final res = await post(Uri.parse(url), body: loginBody);
      jsonDecode(res.body)['status'] == "200";
      return res.body;
    } catch (e) {
      return jsonEncode({"status": '404', "message": 'Link is not Vailid'});
    }
  }

  Future<dynamic> getNotificationList({int? page, int? pageSize}) async {
    try {
      final res = await get(Uri.parse(
          "${baseUrl}get_notification?page=$page&pageSize=$pageSize"));
    } catch (e) {
      return e.toString();
    }
  }
}
