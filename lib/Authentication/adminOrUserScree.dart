import 'package:find/config/config.dart';
import 'package:flutter/material.dart';

class AdminOrUserScreen extends StatefulWidget {
  const AdminOrUserScreen({super.key});

  @override
  State<AdminOrUserScreen> createState() => _AdminOrUserScreen();
}

class _AdminOrUserScreen extends State<AdminOrUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xfff6f6f6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 40,
          ),
          Image.asset(
            "assets/images/img.png",
            height: 200,
          ),
          Column(
            children: const [
              Text(
                "Login",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Sign in as Admin or User or\n Create Account",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 30, left: 30),
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(FindScreens.AdminLogin);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: FindColors.primaryColor),
                  child: const Text(
                    "Admin",
                    style: TextStyle(fontSize: 23),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30),
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(FindScreens.loginScren);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FindColors.primaryColor,
                  ),
                  child: const Text(
                    "User",
                    style: TextStyle(fontSize: 23),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
