import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wissal_app/controller/profile_controller/profile_controller.dart';
import 'package:wissal_app/model/user_model.dart';

class UpdateProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  RxBool isloading = false.obs;
  final getcontroller = Get.find<ProfileController>();

  Future<void> updateProfile(
      String? imgPath, String? name, String? about, String? number) async {
    isloading.value = true;

    try {
      String? imageUrl;

      // التحقق من أن الصورة ليست null أو رابط URL
      final isLocalFile =
          imgPath != null && imgPath.isNotEmpty && !imgPath.startsWith('http');

      if (isLocalFile) {
        final file = File(imgPath);
        final fileName = imgPath.split('/').last;

        final storageBucket = supabase.storage.from('avatars');

        await storageBucket.upload(
          'profile_images/$fileName',
          file,
          fileOptions: const FileOptions(upsert: true),
        );

        imageUrl = storageBucket.getPublicUrl('profile_images/$fileName');
      }

      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final updateuser = UserModel(
          id: userId,
          email: supabase.auth.currentUser!.email,
          name: name,
          about: about,
          profileimage: imageUrl?.isNotEmpty == true
              ? imageUrl
              : getcontroller.currentUser.value.profileimage,
          phonenumber: number,
        );

        await supabase.from('save_users').upsert(updateuser.toJson());
      }

      Get.snackbar("Success", "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM);
      await getcontroller.getUserDetails();
    } catch (e, stacktrace) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      print("==============Caught error===================: $e");
      print("============Stack trace=================: $stacktrace");
    } finally {
      isloading.value = false;
    }
  }
}
