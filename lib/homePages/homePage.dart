import 'package:find/Authentication/loginScreen.dart';
import 'package:find/config/config.dart';
import 'package:find/homePages/LostItems.dart';
import 'package:find/homePages/availalbeAdminsToChat.dart';
import 'package:find/homePages/feedbackPage.dart';
import 'package:find/homePages/pickedItemsBYTheUser.dart';
import 'package:find/homePages/profile.dart';
import 'package:find/homePages/userDashbaord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var userName =
      FindConfig.sharedPreferences!.getString(FindConfig.userName).toString();
  var currentIndex = 0;

  //For Bottom Navigations
  void updaateNavigations(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // Bottom Pages
  List<Widget> bottomPages = [
    const LostItem(),
    const pickedItemsBYTheUser(),
    const showAdminsToChat(),
    const feedbackPage(),
    const editProfileUser(),
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
            label: "Items",
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
        title: userName.isNotEmpty ? Text(userName) : const Text("User"),
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
