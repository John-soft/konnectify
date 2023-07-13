import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konnectify/http/services/auth_service.dart';
import 'package:konnectify/views/screens/authetication/forgot_password.dart';
import 'package:konnectify/views/screens/authetication/phone_login.dart';
import 'package:konnectify/views/screens/authetication/register.dart';
import 'package:konnectify/views/screens/home_screen.dart';
import 'package:konnectify/widgets/custom_button.dart';
import 'package:konnectify/widgets/custom_text_field.dart';
import 'package:konnectify/widgets/text_button.dart';

import '../../../constants/enums.dart';
import '../../../exception_handler.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';

  const LoginScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    title: 'Email',
                    hintText: 'Enter Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextField(
                    obscureText: _isPasswordVisible,
                    controller: _passwordController,
                    title: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    hintText: 'Enter Password',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const SizedBox(height: 24.0),
                  CustomButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                      }
                      _loginUser(email, password);
                    },
                    title: _isLoading == true
                        ? 'Signing In...Please wait'
                        : 'Login',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ButtonText(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            ForgotPasswordScreen.routeName, (route) => false);
                      },
                      staticText: 'Forgot Password ? ',
                      actionText: 'Click here'),
                  SizedBox(
                    height: 16.h,
                  ),
                  ButtonText(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            RegistrationScreen.routeName, (route) => false);
                      },
                      staticText: "I don't have an account ? ",
                      actionText: 'Create new account'),
                  SizedBox(
                    height: 20.h,
                  ),
                  ButtonText(
                      onTap: () {
                        Navigator.pushNamed(
                            context, PhoneNumberLogin.routeName);
                      },
                      staticText: '',
                      actionText: 'Login With Phone Number'),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _loginUser(String email, String password) async {
    final status = await _authService.loginUser(email, password);
    if (status == NetworkResultStatus.successful) {
      Fluttertoast.showToast(msg: 'Signin succesfull!!');
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      final errorMessage =
          AuthExceptionHandler.generateExceptionMessage(status);
      Fluttertoast.showToast(msg: errorMessage);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
