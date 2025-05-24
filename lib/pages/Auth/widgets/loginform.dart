import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wissal_app/controller/auth_controller/login_controller.dart';

import '../../../widgets/custome_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    LoginController loginController = Get.put(LoginController());
    // LoginController()
    return Center(
      child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email_outlined),
              filled: true,
              hintText: 'Email',
              fillColor: Theme.of(context).colorScheme.background,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.password),
              filled: true,
              hintText: 'Password',
              fillColor: Theme.of(context).colorScheme.background,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          loginController.isLoading.value
              ? CircularProgressIndicator()
              : CustomeButton(
                  mytext: 'Login',
                  myicon: Icons.lock,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    // LoginController();
                    loginController.Login(
                        emailController.text, passwordController.text);
                  }),
        ],
      ),
    );
  }
}
