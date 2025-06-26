// ملف: lib/view/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/splach_controller/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Vector.svg',
              width: 150,
              height: 150,
            ),
            // SizedBox(
            //   height: 100,
            // ),
            // Text(
            //   'Dev by:Mohammed Majed Salah',
            //   style: Theme.of(context).textTheme.labelLarge,
            // )
            // const SizedBox(height: 20),
            // const CircularProgressIndicator(
            //   color: Colors.blue,
            // ),
          ],
        ),
      ),
    );
  }
}
