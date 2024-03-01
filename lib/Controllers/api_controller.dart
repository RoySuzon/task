import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

class ApiController {
  final String baseUrl = 'http://sherpur.rbfgroupbd.com/';
  Map<String, String> getHeader(String token) {
    return {"Authorization": "Bearer $token"};
  }

  Future<dynamic> loginApi(dynamic loginBody) async {
    final String url = '${baseUrl}login';
    log(url, name: 'Login Url');
    final body = jsonEncode(loginBody);

    try {
      final res = await post(Uri.parse(url), body: body);
      if (res.statusCode == 200) {
        // print(res.body);
        return res.body;
      } else {
        return res.body;
      }
    } catch (e) {
      return {"status": 'Failed', "message": e.toString()};
    }
  }

  Future<dynamic> getNotificationList({int? page, int? pageSize}) async {
    try {
      final res = await get(
          Uri.parse("${baseUrl}get_notification?page=1&pageSize=100"));
    } catch (e) {
      return e.toString();
    }
  }
}
