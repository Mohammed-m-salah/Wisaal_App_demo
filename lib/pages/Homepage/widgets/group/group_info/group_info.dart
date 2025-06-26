import 'package:flutter/material.dart';
import 'package:wissal_app/model/Group_model.dart';
import 'package:wissal_app/pages/Homepage/widgets/chat_tile.dart';
import 'package:wissal_app/pages/Homepage/widgets/group/group_info/groupMembersInfo.dart';
import '../../../../user_profile/widgets/user_info.dart';

class GroupInfo extends StatelessWidget {
  final GroupModel groupModel;
  const GroupInfo({super.key, required this.groupModel});

  @override
  Widget build(BuildContext context) {
    final String name = groupModel.name ?? "اسم المجموعة";
    final String profileUrl = (groupModel.profileUrl.isNotEmpty ?? false)
        ? groupModel.profileUrl
        : "https://i.ibb.co/V04vrTtV/blank-profile-picture-973460-1280.png";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GroupMemberInfo(
            groupId: groupModel.id,
            profileImage: profileUrl,
            userName: name,
            userEmail: groupModel.name ?? "لا يوجد وصف للمجموعة",
          ),
          const SizedBox(height: 30),
          const Text(
            " Members",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (groupModel.members != null && groupModel.members.isNotEmpty)
            Column(
              children: groupModel.members.map((member) {
                return ChatTile(
                  imgUrl: member.profileimage ?? '',
                  name: member.name ?? 'عضو غير معروف',
                  lastChat: member.email ?? '',
                  lastTime: member.role == "Admin" ? "Admin" : "User",
                );
              }).toList(),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("لا يوجد أعضاء في هذه المجموعة"),
            ),
        ],
      ),
    );
  }
}
