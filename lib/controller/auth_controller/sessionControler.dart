import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionController extends GetxController {
  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null) {
      print("🟢 جلسة موجودة: $userId");
      Get.offAllNamed('/homepage');
    } else {
      print("🔴 لا توجد جلسة");
      Get.offAllNamed('/loginform');
    }
  }
}
