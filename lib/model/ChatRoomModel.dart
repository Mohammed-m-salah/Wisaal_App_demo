import 'package:wissal_app/model/user_model.dart';

import 'chat_model.dart';

class ChatRoomModel {
  String? id;
  String? senderId;
  String? reciverId;
  UserModel? sender;
  UserModel? receiver;
  List<ChatModel>? messages;
  int? unReadMessageNO;
  String? lastMessage;
  DateTime? lastMessageTimeStamp;
  String? timeStamp;
  bool? isTyping = false;

  ChatRoomModel({
    this.id,
    this.senderId,
    this.reciverId,
    this.sender,
    this.receiver,
    this.messages,
    this.unReadMessageNO,
    this.lastMessage,
    this.lastMessageTimeStamp,
    this.timeStamp,
    this.isTyping,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] ?? '',
      senderId: json['senderId'],
      reciverId: json['reciverId'],
      sender:
          json['sender'] != null ? UserModel.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null
          ? UserModel.fromJson(json['receiver'])
          : null,
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((e) => ChatModel.fromJson(e))
          .toList(),
      unReadMessageNO: json['unReadMessageNO'] ?? 0,
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTimeStamp: json['lastMessageTimeStamp'] != null
          ? DateTime.tryParse(json['lastMessageTimeStamp'])
          : null,
      timeStamp: json['timeStamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'reciverId': reciverId,
      'sender': sender?.toJson(),
      'receiver': receiver?.toJson(),
      'messages': messages?.map((e) => e.toJson()).toList(),
      'unReadMessageNO': unReadMessageNO,
      'lastMessage': lastMessage,
      'lastMessageTimeStamp': lastMessageTimeStamp?.toIso8601String(),
      'timeStamp': timeStamp,
    };
  }
}
