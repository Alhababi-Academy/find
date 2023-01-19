import 'dart:async';
import 'package:find/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  bool indicatorCircle = false;
  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => {
              checkUser(context),
            });
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/uc.png",
            width: 250,
          ),
          const Text(
            "University Of The Cordilleras",
            style: TextStyle(
                color: FindColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          const SizedBox(
            height: 30,
          ),
          // indicatorCircle ? const CircularProgressIndicator() : const Text('')
        ],
      ),
    );
  }

  checkUser(BuildContext ctx) async {
    User? user = FindConfig.auth!.currentUser;
    if (user != null) {
      String? currentUser = user.uid;
      await FindConfig.firestore!
          .collection("users")
          .doc(currentUser)
          .get()
          .then(
        (snapshot) async {
          if (await snapshot.data()!['type'] == 'admin') {
            Navigator.of(ctx).pushReplacementNamed(FindScreens.AdminHome);
            print("Admin Type");
          }
          if (await snapshot.data()!['type'] == 'user') {
            Navigator.of(ctx).pushReplacementNamed(FindScreens.homePage);
            print("User Type");
          }
        },
      );
    } else {
      print("No User");
      Navigator.of(ctx).pushReplacementNamed(FindScreens.adminOrUserScreen);
    }
  }
}
