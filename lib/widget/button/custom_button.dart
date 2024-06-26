import 'package:flutter/material.dart';

class GradiantButton extends StatelessWidget {
  const GradiantButton({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 213, 121, 193),
            Color.fromARGB(255, 116, 46, 130),
          ]),
        ),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        )),
      ),
    );
  }
}
