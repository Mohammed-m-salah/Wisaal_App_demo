import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wissal_app/controller/profile_controller/profile_controller.dart';
import 'package:wissal_app/model/user_model.dart';

class GroupMemberInfo extends StatelessWidget {
  final String profileImage;
  final String userName;
  final String userEmail;
  final String groupId;

  const GroupMemberInfo({
    super.key,
    required this.profileImage,
    required this.userName,
    required this.userEmail,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    // يفضل استدعاء الـ controller هنا فقط إذا تم تسجيله مسبقًا
    final ProfileController profileController = Get.find();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xffB8DFF2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber,
                  width: 4,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  profileImage.isNotEmpty
                      ? profileImage
                      : "https://i.ibb.co/V04vrTtV/blank-profile-picture-973460-1280.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://i.ibb.co/V04vrTtV/blank-profile-picture-973460-1280.png",
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              userEmail,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // اجراء الاتصال
                    },
                    icon: const Icon(Icons.call, color: Colors.green),
                    label: const Text(
                      'Call',
                      style: TextStyle(color: Colors.green),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // اجراء مكالمة فيديو
                    },
                    icon: const Icon(Icons.video_call, color: Colors.orange),
                    label: const Text(
                      'Video',
                      style: TextStyle(color: Colors.orange),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      var newMember = UserModel(
                          email: userEmail,
                          name: userName,
                          profileimage: profileImage,
                          role: 'admin');

                      profileController.addMemberToGroup(groupId, newMember);
                    },
                    icon: Icon(
                      Icons.person_add_alt_1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
