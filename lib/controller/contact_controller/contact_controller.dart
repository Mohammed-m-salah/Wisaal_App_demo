import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wissal_app/model/ChatRoomModel.dart';
import 'package:wissal_app/model/user_model.dart';

class ContactController extends GetxController {
  final db = Supabase.instance.client;
  final auth = Supabase.instance.client.auth;

  RxBool isLoading = false.obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<ChatRoomModel> chatRoomList = <ChatRoomModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getUserList();
    getChatRoomList();
  }

  /// جلب كل المستخدمين المسجلين
  Future<void> getUserList() async {
    isLoading.value = true;
    try {
      final data = await db.from('save_users').select();
      userList.value =
          (data as List).map((e) => UserModel.fromJson(e)).toList();

      print("✅ عدد المستخدمين: ${userList.length}");
    } catch (error) {
      print("❌ خطأ أثناء جلب المستخدمين: $error");
    } finally {
      isLoading.value = false;
    }
  }

  /// جلب غرف الدردشة الخاصة بالمستخدم الحالي مع بيانات الطرف الآخر
  Future<void> getChatRoomList() async {
    isLoading.value = true;

    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        throw Exception("❌ المستخدم غير مسجل الدخول");
      }

      final userId = currentUser.id;

      final List roomData = await db.from('chat_rooms').select().or(
            'and(senderId.eq.$userId),and(reciverId.eq.$userId)',
          );

      final List<ChatRoomModel> fetchedRooms = [];

      for (final room in roomData) {
        final chatRoom = ChatRoomModel.fromJson(room);
        print(
            "🧪 lastMessage: ${chatRoom.lastMessage}, lastTime: ${chatRoom.lastMessageTimeStamp}");

        final otherUserId = chatRoom.senderId == userId
            ? chatRoom.reciverId
            : chatRoom.senderId;

        if (otherUserId != null) {
          final userData = await db
              .from('save_users')
              .select()
              .eq('id', otherUserId)
              .maybeSingle();

          if (userData != null) {
            chatRoom.receiver = UserModel.fromJson(userData);
          }
        }

        fetchedRooms.add(chatRoom);
      }

      chatRoomList.value = fetchedRooms;

      print("✅ عدد غرف الدردشة: ${chatRoomList.length}");
    } catch (error) {
      print("❌ خطأ أثناء جلب غرف الدردشة: $error");
      chatRoomList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
