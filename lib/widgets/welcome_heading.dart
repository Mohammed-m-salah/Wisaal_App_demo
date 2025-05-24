import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WelcomHeading extends StatelessWidget {
  const WelcomHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/Vector.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              semanticsLabel: 'Red dash paths',
            ),
          ),
        ),
        Text(
          'Wisaal App',
          style: Theme.of(context).textTheme.headlineLarge,
        )
      ],
    );
  }
}
