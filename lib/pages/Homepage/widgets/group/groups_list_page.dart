import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wissal_app/controller/group_controller/group_controller.dart';
import 'package:wissal_app/pages/Homepage/widgets/chat_tile.dart';
import 'package:wissal_app/pages/Homepage/widgets/group/chat_group/group_chat.dart';

class GroupListPage extends StatelessWidget {
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // تحميل الكونترولر باستخدام GetX
    final GroupController groupController = Get.put(GroupController());

    return Obx(() {
      // عرض رسالة إذا لم تكن هناك مجموعات
      if (groupController.groupList.isEmpty) {
        return const Center(child: Text('لا توجد مجموعات حالياً'));
      }

      // عرض قائمة المجموعات
      return ListView.builder(
        itemCount: groupController.groupList.length,
        itemBuilder: (context, index) {
          final group = groupController.groupList[index];

          final String groupName = group.name?.trim().isNotEmpty == true
              ? group.name!.trim()
              : 'مجموعة بدون اسم';

          final String lastChatText =
              group.lastMessage?.trim().isNotEmpty == true
                  ? group.lastMessage!.trim()
                  : 'لا توجد رسائل';

          final String lastTimeText =
              group.lastMessageTime?.trim().isNotEmpty == true
                  ? _formatTime(group.lastMessageTime!)
                  : '';

          final String imageUrl = (group.profileUrl != null &&
                  group.profileUrl.trim().isNotEmpty &&
                  group.profileUrl.trim().startsWith('http'))
              ? group.profileUrl.trim()
              : 'https://i.ibb.co/jv3bLxbn/group.jpg';

          return InkWell(
            onTap: () => Get.to(() => GroupChat(groupModel: group)),
            child: ChatTile(
              imgUrl: imageUrl,
              name: groupName,
              lastChat: lastChatText,
              lastTime: lastTimeText,
            ),
          );
        },
      );
    });
  }

  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString).toLocal();
      return TimeOfDay.fromDateTime(dateTime)
          .format(Get.context!); // يعرض الوقت فقط حسب اللغة
    } catch (e) {
      return '';
    }
  }
}
