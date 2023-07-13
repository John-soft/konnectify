import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konnectify/utils/styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.title,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? title;
  final String? hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    var bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: AppStyles.titleText.copyWith(
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscuringCharacter: '*',
          scrollPadding: EdgeInsets.only(bottom: bottomInset + 50),
          decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: suffixIcon,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.red,
              ))),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your $title';
            }
            return null;
          },
        ),
      ],
    );
  }
}
