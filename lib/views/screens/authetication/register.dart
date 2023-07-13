import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:konnectify/http/services/auth_service.dart';
import 'package:konnectify/views/screens/authetication/login.dart';
import 'package:konnectify/widgets/custom_text_field.dart';
import 'package:konnectify/widgets/text_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants/enums.dart';
import '../../../exception_handler.dart';

class RegistrationScreen extends StatefulWidget {
  static String routeName = '/register';

  const RegistrationScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hobbiesController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  late bool _isPasswordVisible = true;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _hobbiesController.dispose();
    super.dispose();
  }

  // void _register() {
  //   if (_formKey.currentState!.validate()) {
  //     // Registration logic here
  //     Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  //     String email = _emailController.text;
  //     String phoneNumber = _phoneNumberController.text;
  //     String password = _passwordController.text;
  //     String hobbies = _hobbiesController.text;
  //   }
  // }

  // bool _visibility = false;

  // void toggleVisibilty() {
  //   setState(() {
  //     _visibility = !_visibility;
  //   });
  // }

  final _formKey = GlobalKey<FormState>();

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Registration'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Text(
                    'Create Account',
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
                    controller: _phoneNumberController,
                    title: 'Phone Number',
                    hintText: 'Enter Phone Number',
                    keyboardType: TextInputType.phone,
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
                          : Icons.visibility_off),
                    ),
                    hintText: 'Enter Password',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextField(
                    controller: _hobbiesController,
                    title: 'Hobbies',
                    hintText: 'e.g, Football, Basketball',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    //isLoading: authState.isLoading,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isloading = true;
                        });
                        _createAccount(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      }
                    },

                    child: _isloading == true
                        ? const Text('Setting up your account...')
                        : const Text('Create Account'),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ButtonText(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      staticText: 'Already have account ? ',
                      actionText: 'Login')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _createAccount(String email, String password) async {
    final status = await _authService.createAccount(email, password);
    if (status == NetworkResultStatus.successful) {
      _sendUserDeetsToFirestore();
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);

      setState(() {
        _isloading = false;
      });
    } else {
      final errorMessage =
          AuthExceptionHandler.generateExceptionMessage(status);
      Fluttertoast.showToast(msg: errorMessage);
      setState(() {
        _isloading = false;
      });
    }
  }

  _sendUserDeetsToFirestore() async {
    final status = await _authService.sendDetailsToFirestore(
      _phoneNumberController.text.trim(),
      _hobbiesController.text.trim(),
      _passwordController.text.trim(),
    );
    if (status == NetworkResultStatus.successful) {
      Fluttertoast.showToast(
          msg: 'Your account has been created successfully!');
    } else {
      final errorMessage =
          AuthExceptionHandler.generateExceptionMessage(status);
      Fluttertoast.showToast(msg: errorMessage);
    }
  }
}
