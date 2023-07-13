import 'package:flutter/material.dart';
import 'package:konnectify/http/services/auth_service.dart';

class OTPScreen extends StatelessWidget {
  static const String routeName = '/otp';
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final String verificationId;

  final _key = GlobalKey<FormState>();

  OTPScreen({super.key, required this.verificationId});

  void signInWithOTP(BuildContext context) {
    String smsCode = otpController.text.trim();

    firebaseAuthService.signInWithOTP(verificationId, smsCode, context);
  }

  @override
  Widget build(BuildContext context) {
    //final String verificationId = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _key,
              child: TextField(
                controller: otpController,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Verify OTP'),
              onPressed: () {
                signInWithOTP(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
