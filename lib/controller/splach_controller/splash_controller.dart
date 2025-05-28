import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashController extends GetxController {
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    Splashhandel();
  }

  void Splashhandel() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = supabase.auth.currentUser;

    if (user == null) {
      print("🔴 لا يوجد جلسة مستخدم، الذهاب لصفحة تسجيل الدخول");
      Get.toNamed('/authpage'); // أو /welcome حسب ما تسمي صفحتك
    } else {
      print("✅ مستخدم موجود: ${user.email}");
      Get.toNamed('/homepage');
    }
  }
}
