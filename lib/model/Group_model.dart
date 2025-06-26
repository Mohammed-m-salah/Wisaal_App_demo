import 'dart:convert';

import 'package:wissal_app/model/user_model.dart';

class GroupModel {
  final String id;
  final String? name;
  final String profileUrl;
  final List<UserModel> members;
  final String createdAt;
  final String createdBy;
  final String timestamp;
  final String? lastMessage; // إذا تستخدمه
  final String? lastMessageTime; // إذا تستخدمه

  GroupModel({
    required this.id,
    this.name,
    required this.profileUrl,
    required this.members,
    required this.createdAt,
    required this.createdBy,
    required this.timestamp,
    this.lastMessage,
    this.lastMessageTime,
  });
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    final rawMembers = json['members'];
    List<UserModel> parsedMembers = [];

    if (rawMembers is String) {
      parsedMembers = (jsonDecode(rawMembers) as List<dynamic>)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } else if (rawMembers is List) {
      parsedMembers = rawMembers.map((e) => UserModel.fromJson(e)).toList();
    }

    return GroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      members: parsedMembers,
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      timestamp: json['timestamp'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['timeStamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileUrl': profileUrl,
      'members': members.map((m) => m.toJson()).toList(),
      'createdAt': createdAt,
      'createdBy': createdBy,
      'timeStamp': timestamp,
      'last_message': lastMessage,
    };
  }
}
