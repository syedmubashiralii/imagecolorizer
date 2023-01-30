import 'dart:ui' as ui;
import 'dart:io' as io;
import 'package:dioldifi/Utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Controllers/LoginSignUpController.dart';
import '../Utils/Widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var fullname = TextEditingController();
  var email = TextEditingController();
  var cpassword = TextEditingController();
  var password = TextEditingController();
  bool ishidden = true;

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
          backgroundColor: primarycolor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.man,
                      size: 100,
                    ),
                    const SizedBox(height: 50),
                    //hello
                    const Text(
                      "Hello There!",
                      style: TextStyle(
                          fontFamily: "inter",
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "sign Up to oue app and get free 10 coins",
                      style: TextStyle(fontSize: 16, fontFamily: "trajanbold"),
                    ),
                    const SizedBox(height: 50),
                    MyInputField(
                      controller: fullname,
                      hint: "Name",
                      icon: Icons.person,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyInputField(
                      controller: email,
                      hint: "Email",
                      icon: Icons.mail,
                      onchanged: () {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    MyInputField(
                      controller: cpassword,
                      hint: "Confirm Password",
                      icon: Icons.password,
                      isobsecure: ishidden,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MyButton(
                        text: "Sign Up",
                        onTap: () async {
                          if (fullname.text == "" ||
                              email.text == "" ||
                              cpassword.text == "" ||
                              password.text == "") {
                            ShowSnackbar(
                                context, "Please Enter Complete Information");
                            //return;
                          } else if (cpassword.text.trim() !=
                              password.text.trim()) {
                            ShowSnackbar(context, "Password Does'nt Match");
                          } else {
                            LoginSignup()
                                .SignUp(email.text.trim(), password.text.trim(),
                                    fullname.text.trim(), context)
                                .then(
                              (value) {
                                FocusManager.instance.primaryFocus!.unfocus();
                                Navigator.pop(context);
                              },
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  changepasswordfieldtype() {
    ishidden = !ishidden;
    setState(() {});
  }
}
