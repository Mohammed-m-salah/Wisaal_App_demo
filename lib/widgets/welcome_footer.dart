import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WelcomeFooter extends StatelessWidget {
  const WelcomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SlideAction(
        sliderButtonIcon: SvgPicture.asset(
          'assets/icons/fa-solid_plug.svg',
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        submittedIcon: SvgPicture.asset(
          'assets/icons/fa-solid_plug.svg',
          width: 25,
          height: 25,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        text: 'Slide To Start naw',
        textStyle: Theme.of(context).textTheme.labelLarge,
        innerColor: Theme.of(context).colorScheme.onPrimaryContainer,
        outerColor: Theme.of(context).colorScheme.primaryContainer,
        onSubmit: () {
          Get.offAllNamed('/authpage');
        },
      ),
    );
  }
}
