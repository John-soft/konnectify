import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  const ButtonText(
      {super.key,
      required this.onTap,
      required this.staticText,
      required this.actionText});
  final VoidCallback onTap;
  final String staticText;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          staticText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
                color: Colors.deepPurple, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
