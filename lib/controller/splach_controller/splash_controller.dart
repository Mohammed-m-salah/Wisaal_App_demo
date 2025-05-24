import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashController extends GetxController {
  final supabase = Supabase.instance.client;

  void onInit() {
    super.onInit();
    Splashhandel();
  }

  void Splashhandel() async {
    await Future.delayed(
      Duration(seconds: 3),
    );
    if (supabase.auth.currentUser == null) {
      Get.toNamed('/authpage');
    } else {
      Get.toNamed('/homepage');
      print(
          "====================${supabase.auth.currentUser!.email}=================");
    }
  }
}
