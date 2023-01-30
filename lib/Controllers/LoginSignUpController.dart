// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../UI/LandingPage.dart';
import '../Utils/Constants.dart';
import 'CoinsController.dart';

class LoginSignup {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebasedb = FirebaseFirestore.instance;
  Future SignUp(
      String email, String password, String Name, BuildContext context) async {
    try {
      EasyLoading.show();
      final credential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => adduserdetail(email, Name).then((value) async {
                user = await LoginSignup().CurrentUser();
                await user?.sendEmailVerification().then((value) {
                  SignOut();
                  ShowSnackbar(
                      context, "Check Your email and Verify your account.");
                });
                EasyLoading.dismiss();
              }));
    } on FirebaseAuthException catch (e) {
      ShowSnackbar(context, e.message.toString());
      EasyLoading.dismiss();
    } catch (e) {
      ShowSnackbar(context, e.toString());
      EasyLoading.dismiss();
    }
  }

  Future LogIn(String email, String password, BuildContext context) async {
    try {
      var credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = await LoginSignup().CurrentUser();
      if (user!.emailVerified) {
        ShowSnackbar(context, "Login Successfully");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LandingPage(
                      locale: context.locale,
                    )));
      } else {
        ShowSnackbar(context, "Kindly Verify your Email and then Login Again");
        await user!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      ShowSnackbar(context, e.message.toString());
    } catch (e) {
      ShowSnackbar(context, e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future getcoins() async {
    if (user == null) {
      return "0";
    } else {
      var snapshot =
          await _firebasedb.collection('users').doc(user!.email).get();

      return snapshot["coins"].toString();
    }
  }

  Future getsads() async {
    if (user == null) {
      return false;
    } else {
      var snapshot =
          await _firebasedb.collection('users').doc(user!.email).get();

      return snapshot["adfree"];
    }
  }

  Future adduserdetail(String email, String name) async {
    await _firebasedb
        .collection("users")
        .doc(email)
        .set({"email": email, "name": name, "coins": 10, "adfree": false});
  }

  SignOut() async {
    await _firebaseAuth.signOut().then((value) => null);
  }

  CurrentUser() {
    User? userr = _firebaseAuth.currentUser;
    return userr;
  }

  Future UpdateCoins(int coin, BuildContext context, String email) async {
    await _firebasedb
        .collection('users')
        .doc(email)
        .update({"coins": coin})
        .then((result) {})
        .catchError((onError) {
          print("onError");
        });
  }

  Future UpdateCoinsandads(int coin, BuildContext context, String email) async {
    await _firebasedb
        .collection('users')
        .doc(email)
        .update({"coins": coin, "adfree": true})
        .then((result) {})
        .catchError((onError) {
          print("onError");
        });
  }
}
