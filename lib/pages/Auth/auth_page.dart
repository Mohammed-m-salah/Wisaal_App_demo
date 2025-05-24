import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wissal_app/pages/Auth/widgets/auth_page_body.dart';
import 'package:wissal_app/widgets/welcome_heading.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            WelcomHeading(),
            SizedBox(
              height: 30,
            ),
            AuthPageBody(),
          ],
        ),
      ),
    );
  }
}
