import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wissal_app/controller/contact_controller/contact_controller.dart';
import 'package:wissal_app/pages/Homepage/widgets/chat_tile.dart';
import 'package:wissal_app/pages/chat_page/chat_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '12:00';
    return '${timestamp.hour.toString().padLeft(2, '0')} : ${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.put(ContactController());

    return RefreshIndicator(
      onRefresh: () => contactController.getChatRoomList(),
      child: Obx(() {
        if (contactController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (contactController.chatRoomList.isEmpty) {
          return const Center(child: Text('لا توجد محادثات حالياً'));
        }

        return ListView(
          children: contactController.chatRoomList
              .where((e) => e.receiver != null)
              .map((e) {
            return InkWell(
              onTap: () {
                Get.to(ChatPage(userModel: e.receiver!));
              },
              child: ChatTile(
                imgUrl: e.receiver!.profileimage ??
                    'https://www.shutterstock.com/image-photo/portrait-young-african-black-boy-600nw-509908462.jpg',
                name: e.receiver!.name ?? 'user name',
                lastChat: e.lastMessage ?? 'لا توجد رسالة',
                lastTime: formatTimestamp(e.lastMessageTimeStamp),
              ),
            );

            // return InkWell(
            //   onTap: () {
            //     Get.to(ChatPage(userModel: e.receiver!));
            //   },
            //   child: ChatTile(
            //     imgUrl: e.receiver!.profileimage ??
            //         'https://www.shutterstock.com/image-photo/portrait-young-african-black-boy-600nw-509908462.jpg',
            //     name: e.receiver!.name ?? 'user name',
            //     lastChat: e.lastMessage ?? 'لا توجد رسالة',
            //     lastTime: formatTimestamp(e.lastMessageTimeStamp),
            //   ),
            // );
          }).toList(),
        );
      }),
    );
  }
}
