import 'package:find/DialogBox/errorDialog.dart';
import 'package:find/DialogBox/loadingDialog.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CustomeTextField.dart';
import 'package:flutter/material.dart';

class adminResetPassword extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/images/img.png",
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  Text(
                    "Admin Reset Password",
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
                          hintText: "Email",
                          iconData: Icons.email,
                          isObscure: false,
                          textInputType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 50, left: 50),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        checkIfEmailIsEmpty(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Reset",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkIfEmailIsEmpty(BuildContext context) {
    _email.text.isNotEmpty
        ? resetPasswordFun(context)
        : showDialog(
            context: context,
            builder: (_) => const errorDialog(message: "Please Put Email"),
          );
  }

  resetPasswordFun(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const LoadingAlertDialog(
        message: "Reseting Password",
      ),
    );
    resetingPassword(context);
  }

  resetingPassword(context) {
    FindConfig.auth!.sendPasswordResetEmail(email: _email.text.trim()).then(
      (value) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const errorDialog(message: "Email were sent"),
        );
      },
    ).catchError(
      (error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const errorDialog(
              message: "Please make sure the email is corect"),
        );
      },
    );
  }
}
