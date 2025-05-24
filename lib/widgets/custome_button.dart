import 'package:flutter/material.dart';

class CustomeButton extends StatelessWidget {
  final String mytext;
  final IconData myicon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomeButton({
    Key? key,
    required this.mytext,
    required this.myicon,
    required this.backgroundColor, // <-- أضفنا هنا
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            backgroundColor), // <-- استخدم اللون المرسل
        padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        // shape: MaterialStateProperty.all(
        //   RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(18.0),
        //     side: BorderSide(color: mycolor),
        //   ),
        // ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(myicon, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            mytext,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
