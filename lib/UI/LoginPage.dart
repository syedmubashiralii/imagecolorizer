// ignore_for_file: unnecessary_cast, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_element

import 'package:dioldifi/UI/LandingPage.dart';
import 'package:dioldifi/UI/SignUpPage.dart';
import 'package:dioldifi/Utils/Constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../Controllers/LoginSignUpController.dart';
import '../Utils/Widgets.dart';
import '../Utils/route.dart';
import 'dart:ui' as ui;

// ignore: must_be_immutable
class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    var user = LoginSignup().CurrentUser();
  }

  var email = TextEditingController();
  var password = TextEditingController();
  var querySnapshot;
  bool ishidden = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: primarycolor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.man,
                    size: 100,
                  ),
                  SizedBox(height: 50),
                  //hello
                  Text(
                    "Hello There",
                    style: TextStyle(
                        fontFamily: "inter",
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  const Text(
                    "Wellcome back you've been missed",
                    style: TextStyle(fontSize: 16, fontFamily: "poppins"),
                  ),
                  SizedBox(height: 50),

                  //emailtextfield
                  MyInputField(
                    controller: email,
                    hint: "Email",
                    icon: Icons.email,
                  ),

                  //passwordtextfield
                  MyInputField(
                    controller: password,
                    hint: "Password",
                    icon: Icons.password,
                    suffixicon: InkWell(
                        onTap: () {
                          changepasswordfieldtype();
                        },
                        child: Icon(
                            ishidden ? Icons.remove_red_eye : Icons.cancel)),
                    isobsecure: ishidden,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (email.text == "") {
                        ShowSnackbar(context,
                            "Enter your email,so we send you password reset link");
                      } else {
                        LoginSignup().resetPassword(email.text);
                        ShowSnackbar(context,
                            "Password Reset Link Sent, Check your Inbox/Spam Folder");
                      }
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forget Password? ",
                        style: TextStyle(fontSize: 14, fontFamily: "poppins"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  //login button
                  MyButton(
                      text: 'Login',
                      onTap: () {
                        if (email.text == "" || password.text == "") {
                          ShowSnackbar(
                              context, "Enter Email and password for login");
                        } else {
                          LoginSignup().LogIn(
                              email.text.trim(), password.text.trim(), context);
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  //not a member ?registernow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member? ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(createRoute(const SignUp()));
                        },
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "poppins"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  changepasswordfieldtype() {
    ishidden = !ishidden;
    setState(() {});
  }
}
