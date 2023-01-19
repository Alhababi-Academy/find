import 'package:find/AdminHome/AdminfeedbackPage.dart';
import 'package:find/AdminHome/adminDashbaord.dart';
import 'package:find/AdminHome/adminProfile.dart';
import 'package:find/AdminHome/allUsers.dart';
import 'package:find/AdminHome/chatPage.dart';
import 'package:find/AdminHome/lostItemsAdmin.dart';
import 'package:find/Authentication/loginScreen.dart';
import 'package:find/config/config.dart';
import 'package:find/homePages/feedbackPage.dart';
import 'package:find/homePages/userDashbaord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome> {
  var userName = FindConfig.sharedPreferences!
      .getString(FindConfig.adminUserName)
      .toString();
  var currentIndex = 0;

  //For Bottom Navigations
  void updaateNavigations(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // Bottom Pages
  List<Widget> bottomPages = [
    adminDashbaord(),
    const lostItemsAdmin(),
    const allUsers(),
    chatTech(),
    feedbackPageAdmin(),
    const adminProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.find_replace,
            ),
            label: "Lost Items",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Users",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
            ),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.feedback,
            ),
            label: "Feedback",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
            ),
            label: "Profile",
          ),
        ],
        onTap: updaateNavigations,
        currentIndex: currentIndex,
        selectedItemColor: FindColors.primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: userName.isNotEmpty ? Text("Admin") : const Text("Admin"),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.all(1),
            child: IconButton(
                onPressed: () {
                  FindConfig.auth!.signOut().then(
                    (value) {
                      Navigator.of(context)
                          .pushReplacementNamed(FindScreens.splashScreen);
                    },
                  );
                },
                icon: const Icon(Icons.logout)),
          )
        ],
      ),
      body: bottomPages.elementAt(currentIndex),
    );
  }
}
