import 'package:flutter/material.dart';
import 'package:konnectify/views/screens/authetication/forgot_password.dart';
import 'package:konnectify/views/screens/authetication/login.dart';
import 'package:konnectify/views/screens/authetication/otp_screen.dart';
import 'package:konnectify/views/screens/authetication/phone_login.dart';
import 'package:konnectify/views/screens/authetication/register.dart';
import 'package:konnectify/views/screens/authetication/update_email.dart';
import 'package:konnectify/views/screens/buddies_screen.dart';
import 'package:konnectify/views/screens/discover_screen.dart';
import 'package:konnectify/views/screens/home_screen.dart';
import 'package:konnectify/views/screens/profile_screen.dart';
import 'package:konnectify/views/screens/settings_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  RegistrationScreen.routeName: (context) => const RegistrationScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  BuddiesScreen.routeName: (context) => const BuddiesScreen(),
  DiscoverScreen.routeName: (context) => const DiscoverScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  UpdateEmailScreen.routeName: (context) => const UpdateEmailScreen(),
  PhoneNumberLogin.routeName: (context) => const PhoneNumberLogin(),
  OTPScreen.routeName: (context) => OTPScreen(
        verificationId: '',
      ),
};
