import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:konnectify/http/services/shared_prefs.dart';
import 'package:konnectify/views/screens/home_screen.dart';
import '../../constants/enums.dart';
import '../../exception_handler.dart';
import '../model/user_profile.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;
  late NetworkResultStatus _status;
  final _user = FirebaseAuth.instance.currentUser;
  final UserModel _userModel = UserModel();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<NetworkResultStatus> createAccount(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        _status = NetworkResultStatus.successful;
      } else {
        _status = NetworkResultStatus.undefined;
      }
    } catch (e) {
      log('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<NetworkResultStatus> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        _status = NetworkResultStatus.successful;
        LoginPersistence.saveLoginData(userCredential.user!);
      } else {
        _status = NetworkResultStatus.undefined;
      }
    } catch (e) {
      log('Exception @loginUser: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future logoutUser() async {
    await _auth.signOut();
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }, verificationFailed: (FirebaseAuthException e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Verification Failed'),
              content: Text(e.message!),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          });
    }, codeSent: (String verificationId, int? resendToken) {
      //Navigator.pushNamed(context, '/otp', arguments: verificationId);
    }, codeAutoRetrievalTimeout: (String verificationID) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Code Retrieval Timeout'),
              content: const Text('The OTP code retrieval has timed out'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          });
    });
  }

  Future<void> signInWithOTP(
      String verificationId, String smsCode, BuildContext context) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    try {
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Verification Error'),
            content: Text(e.toString()),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<NetworkResultStatus> sendDetailsToFirestore(
      String phoneNumber, String hobby, String password) async {
    try {
      _userModel.email = _user!.email;
      _userModel.phoneNUmber = phoneNumber;
      _userModel.hobby = hobby;
      _userModel.password = password;
      _userModel.uid = _user!.uid;

      await _firebaseFirestore
          .collection('users')
          .doc(_user!.uid)
          .set(_userModel.toMap());

      //check firebasefirestore to make sure the data has ben sent
      //this code is incorrect
      if (_user!.email != null) {
        _status = NetworkResultStatus.successful;
      } else {
        _status = NetworkResultStatus.undefined;
      }
      //
    } catch (e) {
      log('Exception @loginUser: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future getDetailsFromFirestore() async {
    try {
      await _firebaseFirestore.collection("users").doc(_user!.uid).get();
    } catch (e) {
      log('Exception @loginUser: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return null;
    // return;
  }
}
