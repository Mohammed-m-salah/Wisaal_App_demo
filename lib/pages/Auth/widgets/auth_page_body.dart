import 'package:flutter/material.dart';
import 'package:wissal_app/pages/Auth/widgets/loginform.dart';
import 'package:wissal_app/pages/Auth/widgets/signupform.dart';
import 'package:wissal_app/widgets/custome_button.dart';

class AuthPageBody extends StatefulWidget {
  const AuthPageBody({super.key});

  @override
  State<AuthPageBody> createState() => _AuthPageBodyState();
}

class _AuthPageBodyState extends State<AuthPageBody> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: 335,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tabs (Login / Signup)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab(
                    title: "Login",
                    selected: isLogin,
                    onTap: () {
                      setState(() => isLogin = true);
                    }),
                _buildTab(
                    title: "Signup",
                    selected: !isLogin,
                    onTap: () {
                      setState(() => isLogin = false);
                    }),
              ],
            ),

            const SizedBox(height: 30),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(sizeFactor: animation, child: child),
              ),
              child: isLogin
                  ? const LoginForm(key: ValueKey("login"))
                  : const SignupForm(key: ValueKey("signup")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
      {required String title,
      required bool selected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: selected ? 100 : 0,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
