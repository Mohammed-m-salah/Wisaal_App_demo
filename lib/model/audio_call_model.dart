class AudioCallModel {
  String? id;
  String? callerName;
  String? callerPic;
  String? callerUid;
  String? callerEmail;
  String? reciverName;
  String? reciverPic;
  String? reciverUid;
  String? reciverEmail;
  String? status;

  AudioCallModel({
    this.id,
    this.callerName,
    this.callerPic,
    this.callerUid,
    this.callerEmail,
    this.reciverName,
    this.reciverPic,
    this.reciverUid,
    this.reciverEmail,
    this.status,
  });

  /// ✅ من JSON إلى كائن Dart
  factory AudioCallModel.fromJson(Map<String, dynamic> json) {
    return AudioCallModel(
      id: json['id'],
      callerName: json['callerName'],
      callerPic: json['callerPic'],
      callerUid: json['callerUid'],
      callerEmail: json['callerEmail'],
      reciverName: json['reciverName'],
      reciverPic: json['reciverPic'],
      reciverUid: json['reciverUid'],
      reciverEmail: json['reciverEmail'],
      status: json['status'],
    );
  }

  /// ✅ من كائن Dart إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'callerName': callerName,
      'callerPic': callerPic,
      'callerUid': callerUid,
      'callerEmail': callerEmail,
      'reciverName': reciverName,
      'reciverPic': reciverPic,
      'reciverUid': reciverUid,
      'reciverEmail': reciverEmail,
      'status': status,
    };
  }
}
