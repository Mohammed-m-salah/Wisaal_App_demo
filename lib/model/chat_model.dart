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
      reactions:
          json['reactions'] != null ? List<String>.from(json['reactions']) : [],
      replies: json['replies'] ?? [],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
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
