// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  final int? id;
  final int? userId;
  final dynamic image;
  final String? title;
  final String? description;
  final String? readStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  NotificationModel({
    this.id,
    this.userId,
    this.image,
    this.title,
    this.description,
    this.readStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        userId: json["user_id"],
        image: json["image"],
        title: json["title"],
        description: json["description"],
        readStatus: json["read_status"],
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
        "user_id": userId,
        "image": image,
        "title": title,
        "description": description,
        "read_status": readStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
