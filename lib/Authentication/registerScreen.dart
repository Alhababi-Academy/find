import 'dart:io';

import 'package:find/DialogBox/errorDialog.dart';
import 'package:find/DialogBox/loadingDialog.dart';
import 'package:find/config/config.dart';
import 'package:find/homePages/homePage.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:find/widgets/CustomeTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

// This is choices for the gender
GenderType currentGender = GenderType.male;

enum GenderType { male, female }

class _registerScreenState extends State<registerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _schoolID = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _Cpassword = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xfff6f6f6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      const Text(
                        "Register Here Please",
                        style: TextStyle(
                            color: FindColors.primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomeTextField(
                              textEditingController: _fullName,
                              hintText: "Full Name",
                              iconData: Icons.person,
                              isObscure: false,
                            ),
                            CustomeTextField(
                              textEditingController: _email,
                              hintText: "Email",
                              iconData: Icons.email,
                              isObscure: false,
                              textInputType: TextInputType.emailAddress,
                            ),
                            CustomeTextField(
                              textEditingController: _phoneNumber,
                              hintText: "Phone Number",
                              iconData: Icons.phone,
                              isObscure: false,
                              textInputType: TextInputType.phone,
                            ),
                            CustomeTextField(
                              textEditingController: _password,
                              hintText: "Password",
                              iconData: Icons.password,
                              isObscure: true,
                            ),
                            CustomeTextField(
                              textEditingController: _Cpassword,
                              hintText: "Confirm Password",
                              iconData: Icons.password_outlined,
                              isObscure: true,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: const Text(
                                      'Male',
                                      style: TextStyle(
                                          color: FindColors.primaryColor),
                                    ),
                                    leading: Radio(
                                      activeColor: FindColors.primaryColor,
                                      value: GenderType.male,
                                      groupValue: currentGender,
                                      onChanged: (value) {
                                        setState(() {
                                          currentGender = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: ListTile(
                                    title: const Text(
                                      'Female',
                                      style: TextStyle(
                                          color: FindColors.primaryColor),
                                    ),
                                    leading: Radio(
                                      value: GenderType.female,
                                      activeColor: FindColors.primaryColor,
                                      groupValue: currentGender,
                                      onChanged: (value) {
                                        setState(() {
                                          currentGender = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            CustomeTextField(
                              textEditingController: _schoolID,
                              hintText: "ID",
                              iconData: Icons.person,
                              isObscure: false,
                              textInputType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ValidateData();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: FindColors.primaryColor),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(FindScreens.loginScren);
                        },
                        icon: const Icon(
                          Icons.account_box,
                          color: FindColors.primaryColor,
                        ),
                        label: const Text(
                          "You Have Account ?",
                          style: TextStyle(color: FindColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> ValidateData() async {
    _password.text == _Cpassword.text
        ? _fullName.text.isNotEmpty &&
                _email.text.isNotEmpty &&
                _schoolID.text.isNotEmpty &&
                _phoneNumber.text.isNotEmpty
            ? displayDialogg()
            : displayDialog("Please fill up the form")
        : displayDialog("Password does not match");
  }

  displayDialog(String msg) {
    showDialog(
      context: context,
      builder: (_) => errorDialog(
        message: msg,
      ),
    );
  }

  displayDialogg() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return const LoadingAlertDialog(
          message: "Registering User",
        );
      },
    );
    _registerUser();
  }

  User? user;
  void _registerUser() async {
    await FindConfig.auth
        ?.createUserWithEmailAndPassword(
      email: _email.text.trim(),
      password: _password.text.trim(),
    )
        .then((_auth) {
      user = _auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return errorDialog(
              message: error.message.toString(),
            );
          });
    });

    await saveUserInfoToFireStor(user!).then((value) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (c) => homePage());
      Navigator.pushReplacement(context, route);
    });
  }

  Future saveUserInfoToFireStor(User fUser) async {
    FindConfig.firestore!.collection("users").doc(fUser.uid).set(
      {
        "uid": fUser.uid,
        "type": "user",
        "email": _email.text,
        "name": _fullName.text.trim(),
        "schoolID": _schoolID.text.trim(),
        "phoneNumber": _phoneNumber.text.trim(),
        "gender": currentGender.name.toString(),
      },
    );
    FindConfig.sharedPreferences!
        .setString(FindConfig.userName, _fullName.text.trim());
  }
}
