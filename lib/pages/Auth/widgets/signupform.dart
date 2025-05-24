import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wissal_app/controller/auth_controller/signup_controller.dart';
import '../../../widgets/custome_button.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController namecontroller = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    SignupController signupcontroller = Get.put(SignupController());
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: namecontroller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline),
              filled: true,
              hintText: 'Full Name',
              fillColor: Theme.of(context).colorScheme.background,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.alternate_email_outlined),
              filled: true,
              hintText: 'Email',
              fillColor: Theme.of(context).colorScheme.background,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              filled: true,
              hintText: 'Password',
              fillColor: Theme.of(context).colorScheme.background,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 25),
          signupcontroller.isLoading.value
              ? CircularProgressIndicator()
              : CustomeButton(
                  mytext: 'Sign Up',
                  myicon: Icons.person_add,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    // signupcontroller.initUser(emailController.text,
                    //     namecontroller.text, passwordController.text);
                    // تنفيذ عملية التسجيل
                    signupcontroller.signUp(emailController.text,
                        passwordController.text, namecontroller.text);
                    emailController.clear();
                    passwordController.clear();
                    namecontroller.clear();
                  },
                ),
        ],
      ),
    );
  }
}
