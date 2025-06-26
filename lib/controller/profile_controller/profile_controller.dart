import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wissal_app/model/user_model.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  final db = Supabase.instance.client;

  Rx<UserModel> currentUser = UserModel().obs;
  RxBool isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  /// ✅ جلب بيانات المستخدم الحالي من جدول save_users
  Future<UserModel?> getUserDetails() async {
    isloading.value = true;

    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        print("❌ المستخدم غير مسجل الدخول");
        return null;
      }

      final data = await supabase
          .from('save_users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      print("=====================");
      print("📦 بيانات المستخدم:");
      print(const JsonEncoder.withIndent('  ').convert(data));

      if (data == null) {
        print("❌ لم يتم العثور على بيانات المستخدم");
        return null;
      }

      final user = UserModel.fromJson(data);
      currentUser.value = user;
      return user;
    } catch (e) {
      print("❌ خطأ أثناء جلب بيانات المستخدم: $e");
      return null;
    } finally {
      isloading.value = false;
    }
  }

  /// ✅ رفع صورة إلى Supabase Storage
  Future<String> uploadeFileToSupabase(String imagePath) async {
    final fileName =
        "${const Uuid().v4()}_${imagePath.split('/').last}"; // توليد اسم ملف فريد
    final file = File(imagePath);
    final bucket = supabase.storage.from('avatars'); // اسم bucket في Supabase

    try {
      // رفع الصورة إلى Supabase Storage
      await bucket.upload(fileName, file);

      // الحصول على رابط عام للصورة
      final publicUrl = bucket.getPublicUrl(fileName);
      print("✅ تم رفع الصورة، الرابط: $publicUrl");
      return publicUrl;
    } catch (e) {
      print("❌ خطأ أثناء رفع الصورة: $e");
      return "";
    }
  }

  Future<void> addMemberToGroup(String groupId, UserModel user) async {
    try {
      isloading.value = true;

      final response =
          await db.from('groups').select('members').eq('id', groupId).single();

      if (response == null) {
        throw Exception("المجموعة غير موجودة");
      }

      dynamic membersData = response['members'];

      List<dynamic> membersJson;

      if (membersData == null) {
        membersJson = [];
      } else if (membersData is String) {
        // تفكيك JSON String إلى List
        membersJson = jsonDecode(membersData);
      } else if (membersData is List) {
        membersJson = membersData;
      } else {
        // أي حالة غير متوقعة نعاملها كقائمة فارغة
        membersJson = [];
      }

      bool isAlreadyMember =
          membersJson.any((member) => member['id'] == user.id);

      if (isAlreadyMember) {
        print("العضو موجود مسبقاً في المجموعة");
        return;
      }

      membersJson.add(user.toJson());

      // لو تحتاج تخزين membersJson كـ JSON String في قاعدة البيانات:
      // final membersToStore = jsonEncode(membersJson);
      // ثم تمرير membersToStore

      final updateResponse = await db.from('groups').update({
        'members': membersJson
      }) // أو {'members': membersToStore} حسب نوع الحقل
          .eq('id', groupId);

      if (updateResponse == null) {
        throw Exception("فشل في تحديث أعضاء المجموعة");
      }

      print("تمت إضافة العضو ${user.name} بنجاح إلى المجموعة $groupId");
    } catch (e) {
      print("خطأ أثناء إضافة العضو: $e");
      showError("حدث خطأ أثناء إضافة العضو: $e");
    } finally {
      isloading.value = false;
    }
  }

  void showError(String message) {
    Get.snackbar("خطأ", message,
        backgroundColor: Colors.red, colorText: Colors.white);
    isloading.value = false;
  }
}
