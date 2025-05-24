import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wissal_app/model/user_model.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

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
}
