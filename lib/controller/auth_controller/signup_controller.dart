import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wissal_app/model/user_model.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;

  Future<void> signUp(String email, String password, String name) async {
    final supabase = Supabase.instance.client;
    isLoading.value = true;

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      await initUser(email, name);

      if (response.user != null) {
        Get.snackbar("تم", "تم إنشاء الحساب بنجاح");
        print(
            "✅ signup successful: ${response.user!.email}"); // Navigate to login screen
        Get.offNamed('/homepage');
      } else {
        Get.snackbar("خطأ", "فشل في إنشاء الحساب");
      }
    } on AuthException catch (e) {
      Get.snackbar("خطأ في المصادقة", e.message);
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير متوقع: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initUser(String email, String name) async {
    final supabase = Supabase.instance.client;

    try {
      final existingUser = await supabase
          .from('save_users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (existingUser == null) {
        final newUser = UserModel(
          email: email,
          name: name,
          id: supabase.auth.currentUser!.id,
        );

        await supabase
            .from('save_users')
            .insert(newUser.toJson()); // ✅ هذا ضروري

        print("✅ User inserted successfully");
      } else {
        print("ℹ️ User already exists");
      }
    } catch (e) {
      print("❌ Error in initUser: $e");
    }
  }
}
