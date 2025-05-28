import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wissal_app/controller/profile_controller/profile_controller.dart';
import 'package:wissal_app/model/chat_model.dart';
import 'package:wissal_app/model/user_model.dart';
import 'package:record/record.dart';

import '../../helpers/notification_helper.dart';

class ChatController extends GetxController {
  final auth = Supabase.instance.client.auth;
  final db = Supabase.instance.client;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final isLoading = false.obs;
  final isSending = false.obs;
  final isTyping = false.obs;

  final uuid = Uuid();
  final profileController = Get.put(ProfileController());

  RxString selectedImagePath = ''.obs;
  final record = AudioRecorder();
  RxString currentChatRoomId = ''.obs;

  String path = '';
  String url = '';

  // تسجيل الصوت
  // final Record record = Record(); // تهيئة مسجل الصوت
  final isRecording = false.obs; // حالة التسجيل (يشغل/متوقف)
  RxString selectedAudioPath = ''.obs; // مسار ملف الصوت المسجل

  /// توليد ID ثابت للمحادثة بناءً على المستخدمين (لضمان نفس roomId للطرفين)
  String getRoomId(String targetUserId) {
    String currentUserId = auth.currentUser!.id;
    List<String> ids = [currentUserId, targetUserId];
    ids.sort(); // ترتيب أبجدي
    return ids.join('_');
  }

  UserModel getSender(UserModel currentUser, UserModel targetUser) {
    return currentUser.id == targetUser.id ? currentUser : targetUser;
  }

  UserModel getReciver(UserModel currentUser, UserModel targetUser) {
    return currentUser.id == targetUser.id ? targetUser : currentUser;
  }

  /// إرسال رسالة نصية أو صورة أو صوت
  Future<void> sendMessage(
    String targetUserId,
    String message,
    UserModel targetUser, {
    bool isVoice = false,
  }) async {
    isLoading.value = true;
    isSending.value = true;

    final chatId = uuid.v6();
    final roomId = getRoomId(targetUserId);
    final currentUserId = auth.currentUser!.id;
    final now = DateTime.now().toIso8601String();

    UserModel sender =
        getSender(profileController.currentUser.value, targetUser);
    UserModel reciver =
        getReciver(profileController.currentUser.value, targetUser);

    RxString imgUrl = ''.obs;
    RxString audioUrl = ''.obs;

    // رفع صورة إذا كانت موجودة
    if (selectedImagePath.value.isNotEmpty) {
      imgUrl.value = await profileController
          .uploadeFileToSupabase(selectedImagePath.value);
      print("✅ صورة المستخدم: ${imgUrl.value}");
    }

    // رفع الصوت فقط إذا كان isVoice مفعّلًا
    if (isVoice && selectedAudioPath.value.isNotEmpty) {
      audioUrl.value = await profileController
          .uploadeFileToSupabase(selectedAudioPath.value);
      print("✅ ملف الصوت: ${audioUrl.value}");
    }

    final newChat = ChatModel(
      id: chatId,
      message: message.isNotEmpty ? message : '',
      imageUrl: imgUrl.value,
      audioUrl: audioUrl.value,
      senderId: currentUserId,
      reciverId: targetUserId,
      senderName: profileController.currentUser.value.name,
      timeStamp: now,
    );

    try {
      // إدخال الرسالة في جدول الرسائل
      await db.from('chats').insert({
        'id': chatId,
        'senderId': newChat.senderId,
        'reciverId': targetUserId,
        'senderName': newChat.senderName,
        'message': newChat.message,
        'imageUrl': newChat.imageUrl,
        'audioUrl': newChat.audioUrl,
        'timeStamp': newChat.timeStamp,
        'roomId': roomId,
      });

      // تحديث بيانات آخر رسالة في غرفة الدردشة
      String lastMessage = message.isNotEmpty
          ? message
          : imgUrl.value.isNotEmpty
              ? '📷 صورة'
              : audioUrl.value.isNotEmpty
                  ? '🎤 رسالة صوتية'
                  : '';

      await db.from('chat_rooms').upsert({
        'id': roomId,
        'senderId': currentUserId,
        'reciverId': targetUserId,
        'last_message': lastMessage,
        'last_message_time_stamp': now,
        'created_at': now,
        'un_read_message_no': 0,
      });
    } catch (e) {
      print("❌ Error sending message: $e");
      Get.snackbar('خطأ', 'حدث خطأ أثناء إرسال الرسالة');
    }

    // إعادة التهيئة
    selectedImagePath.value = "";
    selectedAudioPath.value = "";
    isLoading.value = false;
    isSending.value = false;
  }

  start_record() async {
    final location = await getApplicationDocumentsDirectory();
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.m4a';
    path = '${location.path}/$fileName';

    if (await record.hasPermission()) {
      await record.start(
        RecordConfig(),
        path: path,
      );
      isRecording.value = true;
      print('🎤 بدء التسجيل: $path');
    } else {
      print('❌ لا يوجد صلاحية للتسجيل');
    }
  }

  stop_record() async {
    String? finalPath = await record.stop();
    isRecording.value = false;

    if (finalPath != null) {
      selectedAudioPath.value = finalPath;
      print('🛑 توقف التسجيل: $finalPath');
      await upload_record(); // ارفع التسجيل بعد التوقف
    } else {
      print('❌ لم يتم حفظ الملف الصوتي');
    }
  }

  upload_record() async {
    try {
      final supabase = Supabase.instance.client;
      final file = File(selectedAudioPath.value);
      final fileName = selectedAudioPath.value.split('/').last;

      final fileBytes = await file.readAsBytes();

      await supabase.storage.from('avatars').uploadBinary(
            'audioUrl/$fileName',
            fileBytes,
            fileOptions: const FileOptions(
              contentType: 'audio/m4a',
            ),
          );

      final publicUrl =
          supabase.storage.from('avatars').getPublicUrl('audioUrl/$fileName');

      url = publicUrl;
      print('✅ تم رفع الملف الصوتي: $url');

      // تشغيل الصوت مباشرة بعد رفعه
      // await playAudio(url);
    } catch (e) {
      print('❌ خطأ أثناء رفع التسجيل: $e');
    }
  }

  // Future<void> playAudio(String url) async {
  //   try {
  //     await _audioPlayer.setUrl(url);
  //     _audioPlayer.play();
  //     print('▶️ بدأ تشغيل الصوت');
  //   } catch (e) {
  //     print('❌ خطأ في تشغيل الصوت: $e');
  //   }
  // }
  Future<void> playAudio(String url) async {
    try {
      await _audioPlayer.stop(); // 🛑 أوقف الصوت الحالي أولًا
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      print('▶️ بدأ تشغيل الصوت');
    } catch (e) {
      print('❌ خطأ في تشغيل الصوت: $e');
    }
  }

  Future<void> deleteMessage(String messageId, String targetUserId) async {
    try {
      await db.from('chats').delete().eq('id', messageId);
      print("✅ تم حذف الرسالة بنجاح");

      update();
    } catch (e) {
      print("❌ فشل في حذف الرسالة: $e");
      Get.snackbar("خطأ", "فشل حذف الرسالة");
    }
  }

  Stream<List<ChatModel>> getMessages(String targetUserId) {
    final roomId = getRoomId(targetUserId);

    return db
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('roomId', roomId)
        .order('timeStamp', ascending: true)
        .map((data) {
          print('Stream updated: ${data.length} messages'); // تحقق هنا
          return data.map((row) => ChatModel.fromJson(row)).toList();
        });
  }

  /// فلترة المستخدمين بحسب الاسم أو البريد أو أي شرط آخر
  Future<List<UserModel>> filterUsers(String keyword) async {
    try {
      final currentUserId = auth.currentUser!.id;

      final response = await db
          .from('users') // تأكد أن جدول المستخدمين اسمه 'users'
          .select()
          .neq('id', currentUserId) // استثناء المستخدم الحالي
          .ilike('name',
              '%$keyword%'); // فلترة بالاسم (يمكنك تغييره إلى email مثلاً)

      final users = (response as List)
          .map((userData) => UserModel.fromJson(userData))
          .toList();

      return users;
    } catch (e) {
      print('❌ خطأ أثناء فلترة المستخدمين: $e');
      return [];
    }
  }

  void listenToIncomingMessages() {
    final currentUserId = auth.currentUser!.id;

    db
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('reciverId', currentUserId)
        .listen((List<Map<String, dynamic>> data) {
          if (data.isNotEmpty) {
            final message = data.last;
            final sender = message['senderName'] ?? 'مرسل مجهول';
            final text = message['message'] ?? '';
            final imageUrl = message['imageUrl'] ?? '';
            final audioUrl = message['audioUrl'] ?? '';
            final incomingRoomId = message['roomId'] ?? '';

            // ✅ تحديد عنوان الرسالة حسب نوع المحتوى
            String messageTitle = '';
            if (audioUrl.isNotEmpty) {
              messageTitle = '🎤 أرسل رسالة صوتية';
            } else if (imageUrl.isNotEmpty) {
              messageTitle = '📷 أرسل صورة';
            } else if (text.isNotEmpty) {
              messageTitle = text;
            } else {
              messageTitle = '📩 رسالة جديدة';
            }

            if (incomingRoomId != currentChatRoomId.value) {
              showChatSnackbar(
                senderName: 'المرسل: $sender',
                messageTitle: messageTitle,
              );
            }
          }
        });
  }
}
