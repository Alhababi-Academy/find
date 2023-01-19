import 'dart:io';
import 'package:find/DialogBox/errorDialog.dart';
import 'package:find/DialogBox/loadingDialog.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CustomeTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:image_picker/image_picker.dart';

class adminProfile extends StatefulWidget {
  const adminProfile({super.key});

  @override
  State<adminProfile> createState() => _adminProfileState();
}

// This is choices for the gender
late GenderType currentGender;

enum GenderType { male, female }

class _adminProfileState extends State<adminProfile> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  User? user = FindConfig.auth!.currentUser;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController schoolID = TextEditingController();
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String _imageUrl = '';

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Edit Profile",
            style: TextStyle(
                color: FindColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 33,
                letterSpacing: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  CustomeTextField(
                    textEditingController: name,
                    hintText: "Full Name",
                    iconData: Icons.person,
                    isObscure: false,
                  ),
                  CustomeTextField(
                    textEditingController: email,
                    hintText: "Email",
                    iconData: Icons.email,
                    enabledEdit: false,
                    isObscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  CustomeTextField(
                    textEditingController: phoneNumber,
                    hintText: "Phone Number",
                    iconData: Icons.phone,
                    isObscure: false,
                    textInputType: TextInputType.phone,
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Expanded(
                  //       child: ListTile(
                  //         title: const Text(
                  //           'Male',
                  //           style: TextStyle(color: FindColors.primaryColor),
                  //         ),
                  //         leading: Radio(
                  //           activeColor: FindColors.primaryColor,
                  //           value: GenderType.male,
                  //           groupValue: currentGender,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               currentGender = value!;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     Flexible(
                  //       child: ListTile(
                  //         title: const Text(
                  //           'Female',
                  //           style: TextStyle(color: FindColors.primaryColor),
                  //         ),
                  //         leading: Radio(
                  //           value: GenderType.female,
                  //           activeColor: FindColors.primaryColor,
                  //           groupValue: currentGender,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               currentGender = value!;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // CustomeTextField(
                  //   textEditingController: schoolID,
                  //   hintText: "ID",
                  //   iconData: Icons.person,
                  //   isObscure: false,
                  //   textInputType: TextInputType.number,
                  // ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              updatingData();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: FindColors.primaryColor),
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Update Date",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> gettingData() async {
    String currentUser = FindConfig.auth!.currentUser!.uid;
    var results =
        await FindConfig.firestore!.collection("users").doc(currentUser).get();
    if (results.exists) {
      name.text = results.data()!['name'];
      email.text = results.data()!['email'];
      phoneNumber.text = results.data()!['phoneNumber'];
      // currentGender = results.data()!['gender'];
      // setState(() {
      //   currentGender;
      // });
    }
  }

  Future updatingData() async {
    User? user = FindConfig.auth!.currentUser;
    String uid = user!.uid;

    showDialog(
      context: context,
      builder: (c) => const LoadingAlertDialog(
        message: "Saving Data...",
      ),
    );

    await FindConfig.firestore!.collection("users").doc(uid).update({
      "name": name.text.trim(),
      "email": email.text.trim(),
      "phoneNumber": phoneNumber.text.trim(),
    }).then((value) {
      Navigator.pop(context);
    });
  }
}
