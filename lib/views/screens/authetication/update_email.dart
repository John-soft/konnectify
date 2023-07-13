import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:konnectify/exception_handler.dart';
import 'package:konnectify/widgets/custom_button.dart';
import 'package:konnectify/widgets/custom_text_field.dart';

import '../../../constants/enums.dart';

class UpdateEmailScreen extends StatefulWidget {
  static const String routeName = '/update_email';
  const UpdateEmailScreen({super.key});

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  static late NetworkResultStatus _status;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<NetworkResultStatus> updateEmail(String newEmail) async {
    final firebaseUser = _firebaseAuth.currentUser;
    await firebaseUser!
        .updateEmail(newEmail)
        .then((value) => _status = NetworkResultStatus.successful)
        .catchError((e) => _status = AuthExceptionHandler.handleException(e));

    return _status;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                const SizedBox(height: 70),
                const Text(
                  "Update Email",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please enter your previous email address to set the new email.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  title: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter previous email',
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        final email = _emailController.text.trim();
                        final status = await updateEmail(email);
                        if (status == NetworkResultStatus.successful) {
                          Fluttertoast.showToast(
                              msg: 'Check your mail for link');
                        } else {
                          Fluttertoast.showToast(msg: 'Error, try again');
                        }
                      }
                    },
                    title: 'Update')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
