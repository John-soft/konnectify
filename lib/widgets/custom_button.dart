import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.loadingColor,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String title;
  final bool isLoading;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50)),
      child: isLoading
          ? SizedBox(
              height: 20.w,
              width: 20.w,
              child: CircularProgressIndicator(
                color: loadingColor ?? Colors.white,
              ),
            )
          : Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
