import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konnectify/http/services/auth_service.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class PhoneNumberLogin extends StatefulWidget {
  static String routeName = '/phone_login';
  const PhoneNumberLogin({super.key});

  @override
  State<PhoneNumberLogin> createState() => _PhoneNumberLoginState();
}

class _PhoneNumberLoginState extends State<PhoneNumberLogin> {
  final _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService phoneAuthProvider = FirebaseAuthService();
  bool _isLoading = false;

  void verifyPhoneNumber(BuildContext context) {
    String phoneNumber = _phoneNumberController.text.trim();
    phoneAuthProvider.verifyPhoneNumber(phoneNumber, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Login With Phone Number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Form(
                  key: _formKey,
                  child: CustomTextField(
                    controller: _phoneNumberController,
                    title: 'Phone Number',
                    hintText: 'Enter 11 digits phone number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 24.0),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                    }
                    verifyPhoneNumber(context);
                  },
                  title: _isLoading == true
                      ? 'Sending OTP...Please wait'
                      : 'Get OTP',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
