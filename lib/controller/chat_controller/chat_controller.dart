import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wissal_app/controller/profile_controller/profile_controller.dart';
import 'package:wissal_app/model/chat_model.dart';
import 'package:wissal_app/model/user_model.dart';
import 'package:record/record.dart';

class ChatController extends GetxController {
  final auth = Supabase.instance.client.auth;
  final db = Supabase.instance.client;

  final isLoading = false.obs;
  final isSending = false.obs;
  final isTyping = false.obs;

  final uuid = Uuid();
  final profileController = Get.put(ProfileController());

  RxString selectedImagePath = ''.obs;

  // تسجيل الصوت
  final Record record = Record(); // تهيئة مسجل الصوت
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

  Future<void> startRecording() async {
    bool hasPermission = await record.hasPermission();
    if (hasPermission) {
      await record.start(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
      isRecording.value = true;
    } else {
      Get.snackbar('خطأ', 'لم يتم منح صلاحية الميكروفون');
    }
  }

  /// إيقاف التسجيل وحفظ المسار
  Future<void> stopRecording() async {
    final path = await record.stop();
    isRecording.value = false;
    if (path != null) {
      selectedAudioPath.value = path;
      print("تم تسجيل الصوت: $path");
    }
  }

  /// حذف رسالة
  Future<void> deleteMessage(String messageId) async {
    try {
      await db.from('chats').delete().eq('id', messageId);
      print("✅ تم حذف الرسالة بنجاح");
    } catch (e) {
      print("❌ فشل في حذف الرسالة: $e");
      Get.snackbar("خطأ", "فشل حذف الرسالة");
    }
  }

  /// جلب الرسائل للمحادثة (Stream)
  Stream<List<ChatModel>> getMessages(String targetUserId) {
    final roomId = getRoomId(targetUserId);

    return db
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('roomId', roomId)
        .order('timeStamp', ascending: true)
        .map((data) => data.map((row) => ChatModel.fromJson(row)).toList());
  }
  // Future<void> updateTypingStatus(String targetUserId, bool typing) async {
  //   final roomId = getRoomId(targetUserId);

  //   try {
  //     await db
  //         .from('chat_rooms')
  //         .update({'is_Typing': typing}).eq('id', roomId);
  //   } catch (e) {
  //     print("خطأ في تحديث isTyping: $e");
  //   }
  // }

  // Stream<bool> listenToTyping(String targetUserId) {
  //   final roomId = getRoomId(targetUserId);

  //   return db
  //       .from('chat_rooms')
  //       .stream(primaryKey: ['id'])
  //       .eq('id', roomId)
  //       .map((event) {
  //         if (event.isEmpty) return false;
  //         final data = event.first;
  //         return data['is_Typing'] as bool? ?? false;
  //       });
  // }
}
