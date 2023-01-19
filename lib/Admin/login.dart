import 'package:find/AdminHome/adminHome.dart';
import 'package:find/DialogBox/errorDialog.dart';
import 'package:find/DialogBox/loadingDialog.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CustomeTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLogin();
}

class _AdminLogin extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff6f6f6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/images/img.png",
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                Text(
                  "Admin Login",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 27,
                      fontWeight: FontWeight.bold),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomeTextField(
                        textEditingController: _email,
                        hintText: "ID",
                        iconData: Icons.person,
                        isObscure: false,
                        textInputType: TextInputType.emailAddress,
                      ),
                      CustomeTextField(
                        textEditingController: _password,
                        hintText: "Password",
                        iconData: Icons.lock,
                        isObscure: isEnabled,
                        hidePassowrdIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isEnabled = !isEnabled;
                            });
                          },
                          child: isEnabled
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 50, left: 50),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      loginUser(_email.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(FindScreens.adminResetPassword);
                  },
                  icon: const Icon(
                    Icons.lock,
                    color: FindColors.primaryColor,
                  ),
                  label: const Text(
                    "Forget Password?",
                    style: TextStyle(
                      color: FindColors.primaryColor,
                    ),
                  ),
                ),

                // TextButton.icon(
                //   onPressed: () {
                //     Navigator.of(context)
                //         .pushReplacementNamed(FindScreens.registerScreen);
                //   },
                //   icon: const Icon(
                //     Icons.account_box,
                //     color: FindColors.primaryColor,
                //   ),
                //   label: const Text(
                //     "You Have no Account? Register Now",
                //     style: TextStyle(
                //       color: FindColors.primaryColor,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  User? firebaseUser;
  void loginUser(String SchoolID) async {
    _email.text.isNotEmpty && _password.text.isNotEmpty
        ? showLoadingDialog(SchoolID)
        : showDialog(
            context: context,
            builder: (_) =>
                const errorDialog(message: "ID or Passowrd is Empty"),
          );
  }

  void showLoadingDialog(String SchoolID) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) {
        return const LoadingAlertDialog(
          message: "Authenticating, Please wait...",
        );
      },
    );
    gettingEmial(SchoolID);
  }

  gettingEmial(SchoolIDNew) async {
    var ddddd = FindConfig.firestore!
        .collection("users")
        .where("schoolID", isEqualTo: SchoolIDNew)
        .get()
        .then(
      (value) async {
        if (value.docs.isNotEmpty) {
          var EmailRetrived = value.docs[0]['email'].toString().trim();
          print(EmailRetrived);
          if (EmailRetrived != null) {
            await FindConfig.auth!
                .signInWithEmailAndPassword(
              email: EmailRetrived.toString().trim(),
              password: _password.text.trim(),
            )
                .then((authUser) {
              firebaseUser = authUser.user;
            }).catchError(
              (error) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (c) {
                    return errorDialog(
                      message: error.message.toString(),
                    );
                  },
                );
              },
            );
            if (firebaseUser != null) {
              readData(firebaseUser!);
            }
          }
        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (_) => const errorDialog(message: "ID does not Exisit"),
          );
        }
      },
    );
  }

  Future readData(User currentUser) async {
    await FindConfig.firestore!
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      FindConfig.sharedPreferences!
          .setString(FindConfig.userName, snapshot.data()!['name']);
      if (snapshot.data()!['type'] == 'admin') {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => const AdminHome());
        Navigator.pushReplacement(context, route);
      } else {
        showDialog(
          context: context,
          builder: (_) => const errorDialog(
              message: "Please chekc the porivded informations"),
        );
      }
    });
  }
}
