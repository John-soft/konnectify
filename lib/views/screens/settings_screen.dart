import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konnectify/exception_handler.dart';
import 'package:konnectify/http/services/auth_service.dart';
import 'package:konnectify/http/services/shared_prefs.dart';
import 'package:konnectify/views/screens/authetication/forgot_password.dart';
import 'package:konnectify/views/screens/authetication/login.dart';
import 'package:konnectify/views/screens/authetication/update_email.dart';
import 'package:konnectify/widgets/settings_card.dart';

import '../../constants/enums.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  static late NetworkResultStatus _status;

  Future<NetworkResultStatus> verifyEmail() async {
    await FirebaseAuth.instance.currentUser!
        .sendEmailVerification()
        .then((value) => _status == NetworkResultStatus.successful)
        .catchError((e) => _status == AuthExceptionHandler.handleException(e));
    return _status;
  }

  Future<void> _handleLogout(BuildContext context) async {
    await LoginPersistence.clearLoginData();
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20.h,
          ),
          SettingsCard(
            onTap: () async {
              final status = await verifyEmail();
              if (status == NetworkResultStatus.successful) {
                Fluttertoast.showToast(msg: 'Check mail for verification link');
              } else {
                Fluttertoast.showToast(msg: 'Error, Please try again');
              }
            },
            text: "Verify Email",
            icon: Icons.email,
          ),
          SettingsCard(
            onTap: () {
              Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
            },
            text: "Change Password",
            icon: Icons.lock,
          ),
          SettingsCard(
            onTap: () {
              Navigator.pushNamed(context, UpdateEmailScreen.routeName);
            },
            text: "Update Email",
            icon: Icons.email,
          ),
          SettingsCard(
            onTap: () {},
            text: "Update Username",
            icon: Icons.person,
          ),
          SettingsCard(
            onTap: () {
              _handleLogout(context);
            },
            text: "Logout",
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }
}
