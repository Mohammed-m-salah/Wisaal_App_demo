import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wissal_app/controller/profile_controller/profile_controller.dart';

class UserInfo extends StatelessWidget {
  final String profileImage;
  final String userName;
  final String userEmail;
  const UserInfo(
      {super.key,
      required this.profileImage,
      required this.userName,
      required this.userEmail});

  @override
  Widget build(BuildContext context) {
    ProfileController profilecontroller = Get.put(ProfileController());
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer, // لون الإطار
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 80, // حجم الدائرة
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xffB8DFF2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber, // لون الإطار
                    width: 4, // سمك الإطار
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    profilecontroller.currentUser.value.profileimage ??
                        "https://i.ibb.co/V04vrTtV/blank-profile-picture-973460-1280.png",
                    scale: 5,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              userName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(userEmail, style: Theme.of(context).textTheme.labelMedium),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // الإجراء عند الضغط
                    },
                    icon: const Icon(Icons.call, color: Colors.green),
                    label: const Text(
                      'Call',
                      style: TextStyle(color: Colors.green),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      side: const BorderSide(color: Colors.green), // الحافة
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // الزوايا
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // الإجراء عند الضغط
                    },
                    icon: const Icon(Icons.video_call, color: Colors.orange),
                    label: const Text(
                      'Video',
                      style: TextStyle(color: Colors.orange),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,

                      side: const BorderSide(color: Colors.orange), // الحافة
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // الزوايا
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // الإجراء عند الضغط
                    },
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Vector.svg', // عدّل المسار حسب موقع ملف SVG
                          color: Theme.of(context).colorScheme.primary,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Call',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
