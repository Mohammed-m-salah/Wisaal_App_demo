import 'dart:convert';

class ChatModel {
  String? id;
  String? message;
  String? senderName;
  String? senderId;
  String? reciverId;
  String? timeStamp;
  String? readStatus;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? documentUrl;
  List<String>? reactions;
  List<dynamic>? replies;

  ChatModel({
    this.id,
    this.message,
    this.senderName,
    this.senderId,
    this.reciverId,
    this.timeStamp,
    this.readStatus,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl = '',
    this.documentUrl,
    this.reactions,
    this.replies,
  });

  /// تحويل نص أو قائمة إلى List<String>
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value);
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) return List<String>.from(decoded);
      } catch (_) {}
    }
    return [];
  }

  /// تحويل نص أو قائمة إلى List<dynamic>
  static List<dynamic> _parseDynamicList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value;
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) return decoded;
      } catch (_) {}
    }
    return [];
  }

  // From JSON
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'],
      senderName: json['senderName'],
      senderId: json['senderId'],
      reciverId: json['reciverId'],
      timeStamp: json['timeStamp'],
      readStatus: json['readStatus'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
      documentUrl: json['documentUrl'],
      reactions: _parseStringList(json['reactions']),
      replies: _parseDynamicList(json['replies']),
    );
  }

  // To JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'senderName': senderName,
      'senderId': senderId,
      'reciverId': reciverId,
      'timeStamp': timeStamp,
      'readStatus': readStatus,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'documentUrl': documentUrl,
      'reactions': reactions ?? [],
      'replies': replies ?? [],
    };
  }
}
