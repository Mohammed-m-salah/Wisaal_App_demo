import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var loginError = ''.obs;

  Future<void> Login(String email, String password) async {
    final supabase = Supabase.instance.client;
    isLoading.value = true;
    loginError.value = '';

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Successful login
        debugPrint("✅ Login successful: ${response.user!.email}");
        Get.offAllNamed('/homepage');

        // Navigate or update UI state
        Get.snackbar("Success", "Logged in as ${response.user!.email}");
      } else {
        loginError.value = "Login failed. Please check your credentials.";
        Get.snackbar("Error", loginError.value);
      }
    } on AuthException catch (e) {
      loginError.value = e.message;
      Get.snackbar("Auth Error", e.message);
    } catch (e) {
      loginError.value = "An unexpected error occurred.";
      Get.snackbar("Error", loginError.value);
    }
  }
}
