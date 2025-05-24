import 'package:flutter/material.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
                child: Image.asset(
                  'assets/images/boy.png',
                  scale: 5,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Image.asset('assets/icons/Vector.png'),
            Container(
              width: 80, // حجم الدائرة
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xffCCC1F0),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue, // لون الإطار
                  width: 4, // سمك الإطار
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/girl.png',
                  scale: 5,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          'Now You Are',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 1),
        Text(
          'Connected',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            textAlign: TextAlign.center,
            'Perfect solution of connexct with anyone easly and more secure',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
