// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  final String? status;
  final String? message;
  final Error? error;
  final Data? data;

  UserInfo({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        status: json["status"],
        message: json["message"],
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "error": error?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  final UserDetails? userDetails;
  final String? token;

  Data({
    this.userDetails,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userDetails: json["user_details"] == null
            ? null
            : UserDetails.fromJson(json["user_details"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user_details": userDetails?.toJson(),
        "token": token,
      };
}

class UserDetails {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final dynamic nid;
  final String? gender;
  final String? image;
  final dynamic presentAddress;
  final dynamic permanentAddress;
  final String? medium;
  final String? sync;
  final dynamic emailVerified;
  final String? phoneVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  UserDetails({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.nid,
    this.gender,
    this.image,
    this.presentAddress,
    this.permanentAddress,
    this.medium,
    this.sync,
    this.emailVerified,
    this.phoneVerified,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        nid: json["nid"],
        gender: json["gender"],
        image: json["image"],
        presentAddress: json["present_address"],
        permanentAddress: json["permanent_address"],
        medium: json["medium"],
        sync: json["sync"],
        emailVerified: json["email_verified"],
        phoneVerified: json["phone_verified"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "nid": nid,
        "gender": gender,
        "image": image,
        "present_address": presentAddress,
        "permanent_address": permanentAddress,
        "medium": medium,
        "sync": sync,
        "email_verified": emailVerified,
        "phone_verified": phoneVerified,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Error {
  final String? error;

  Error({
    this.error,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
      };
}
