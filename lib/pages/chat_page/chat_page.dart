import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wissal_app/controller/chat_controller/chat_controller.dart';
import 'package:wissal_app/controller/image_picker/image_picker.dart';
import 'package:wissal_app/controller/profile_controller/profile_controller.dart';
import 'package:wissal_app/model/chat_model.dart';
import 'package:wissal_app/model/user_model.dart';
import 'package:wissal_app/pages/chat_page/widget/chat_pubbel.dart';
import 'package:wissal_app/pages/user_profile/profile_page.dart';

class ChatPage extends StatefulWidget {
  final UserModel userModel;
  const ChatPage({super.key, required this.userModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController chatcontroller;
  late ProfileController profileController;
  late ImagePickerController imagePickerController;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    chatcontroller = Get.put(ChatController());
    profileController = Get.put(ProfileController());
    imagePickerController = Get.put(ImagePickerController());

    // تعيين ID غرفة الدردشة بناءً على المستخدم المحدد
    chatcontroller.currentChatRoomId.value =
        chatcontroller.getRoomId(widget.userModel.id!);

    // تحديث حالة الكتابة عند تغير النص في حقل الرسالة
    messageController.addListener(() {
      chatcontroller.isTyping.value = messageController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // دالة للتمرير إلى أحدث رسالة مع التأكد من وجود عملاء ScrollController
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = widget.userModel;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: InkWell(
          onTap: () {
            Get.to(() => UserProfilePage(userModel: userModel));
          },
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
                  userModel.profileimage ??
                      'https://i.ibb.co/V04vrTtV/blank-profile-picture-973460-1280.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userModel.name ?? "user_name",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "online",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<List<ChatModel>>(
                  stream: chatcontroller.getMessages(userModel.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text("Error loading messages"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No Messages"));
                    }

                    final messages = snapshot.data!.reversed.toList();

                    // قم بالتمرير بعد بناء الواجهة
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      scrollToBottom();
                    });

                    return ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatBubbel(
                          audioUrl: message.audioUrl ?? "",
                          message: message.message ?? '',
                          isComming: message.senderId ==
                              profileController.currentUser.value.id,
                          iscolor: Colors.amber,
                          time: message.timeStamp != null
                              ? DateFormat('hh:mm a').format(
                                  DateTime.parse(message.timeStamp!),
                                )
                              : '',
                          status: "Read",
                          imgUrl: message.imageUrl ?? "",
                          onDelete: message.senderId ==
                                  profileController.currentUser.value.id
                              ? () {
                                  Get.defaultDialog(
                                    title: "حذف الرسالة",
                                    middleText:
                                        "هل أنت متأكد من حذف هذه الرسالة؟",
                                    textCancel: "إلغاء",
                                    textConfirm: "حذف",
                                    confirmTextColor: Colors.white,
                                    onConfirm: () async {
                                      await chatcontroller.deleteMessage(
                                        message.id!,
                                        chatcontroller.currentChatRoomId.value,
                                      );
                                      Get.back(); // إغلاق النافذة
                                    },
                                  );
                                }
                              : null,
                        );
                      },
                    );
                  },
                ),

                // عرض الصورة المختارة قبل الإرسال
                Obx(
                  () => (chatcontroller.selectedImagePath.value != "")
                      ? Positioned(
                          bottom: 70,
                          left: 10,
                          right: 10,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image: FileImage(
                                  File(chatcontroller.selectedImagePath.value),
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  chatcontroller.selectedImagePath.value = "";
                                },
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // حقل الإدخال والزر
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Obx(
                    () => chatcontroller.isTyping.value
                        ? IconButton(
                            onPressed: () {
                              // يمكن هنا فتح Emoji Picker
                            },
                            icon: const Icon(Icons.emoji_emotions_outlined,
                                color: Colors.white),
                          )
                        : InkWell(
                            onLongPress: () async {
                              if (!chatcontroller.isRecording.value) {
                                await chatcontroller.start_record();
                              }
                            },
                            onTap: () async {
                              if (chatcontroller.isRecording.value) {
                                await chatcontroller.stop_record();
                                await chatcontroller.sendMessage(
                                  widget.userModel.id!,
                                  '',
                                  widget.userModel,
                                  isVoice: true,
                                );
                              }
                            },
                            child: Obx(() => Icon(
                                  chatcontroller.isRecording.value
                                      ? Icons.stop
                                      : Icons.mic,
                                  color: Colors.white,
                                )),
                          ),
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => chatcontroller.selectedImagePath.value == ""
                          ? IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (_) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.photo),
                                          title: const Text("اختر من المعرض"),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final path =
                                                await imagePickerController
                                                    .pickImageFromGallery();
                                            if (path.isNotEmpty) {
                                              chatcontroller.selectedImagePath
                                                  .value = path;
                                            }
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text("استخدم الكاميرا"),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final path =
                                                await imagePickerController
                                                    .pickImageFromCamera();
                                            if (path.isNotEmpty) {
                                              chatcontroller.selectedImagePath
                                                  .value = path;
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/mynaui_image.svg',
                                height: 25,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                chatcontroller.selectedImagePath.value = "";
                              },
                              icon:
                                  const Icon(Icons.close, color: Colors.amber),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          if (messageController.text.trim().isNotEmpty ||
                              chatcontroller
                                  .selectedImagePath.value.isNotEmpty) {
                            chatcontroller.sendMessage(
                              widget.userModel.id!,
                              messageController.text.trim(),
                              widget.userModel,
                            );
                            messageController.clear();
                            chatcontroller.isTyping.value = false;
                            chatcontroller.selectedImagePath.value = "";
                          } else {
                            Get.snackbar(
                              'تنبيه',
                              'لا يمكنك إرسال رسالة فارغة',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white.withOpacity(.1),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(12),
                              borderRadius: 10,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          'assets/icons/iconamoon_send-fill.svg',
                          height: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
