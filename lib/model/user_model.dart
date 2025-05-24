// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? profileimage;
  final String? phonenumber;
  final String? about;
  final String? createdAt;
  final String? lastOnlineStatus;
  final String? status;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.profileimage,
    this.phonenumber,
    this.about,
    this.createdAt,
    this.lastOnlineStatus,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] as String?, // تأكد من هذا السطر
      email: json['email'],
      profileimage: json['profileimage'],
      phonenumber: json['phonenumber'],
      about: json['about'],
      createdAt: json['createdAt'],
      lastOnlineStatus: json['lastOnlineStatus'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileimage': profileimage,
      'phonenumber': phonenumber,
      'about': about ?? '',
      'createdAt': createdAt,
      'lastOnlineStatus': lastOnlineStatus,
      'status': status,
    };
  }
}
