import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/Admin/login.dart';
import 'package:find/Admin/resetPassword.dart';
import 'package:find/AdminHome/adminDashbaord.dart';
import 'package:find/AdminHome/adminHome.dart';
import 'package:find/AdminHome/adminProfile.dart';
import 'package:find/AdminHome/allUsers.dart';
import 'package:find/AdminHome/editItem.dart';
import 'package:find/AdminHome/AdminfeedbackPage.dart';
import 'package:find/AdminHome/foundedItemsAdmin.dart';
import 'package:find/AdminHome/lostItemsAdmin.dart';
import 'package:find/Authentication/adminOrUserScree.dart';
import 'package:find/Authentication/loginScreen.dart';
import 'package:find/Authentication/registerScreen.dart';
import 'package:find/Authentication/resetPassword.dart';
import 'package:find/config/config.dart';
import 'package:find/firebase_options.dart';
import 'package:find/homePages/LostItems.dart';
import 'package:find/homePages/availalbeAdminsToChat.dart';
import 'package:find/homePages/feedbackPage.dart';
import 'package:find/homePages/homePage.dart';
import 'package:find/homePages/pickedItemsBYTheUser.dart';
import 'package:find/homePages/profile.dart';
import 'package:find/homePages/userDashbaord.dart';
import 'package:find/splashScreen/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FindConfig.firestore = FirebaseFirestore.instance;
  FindConfig.auth = FirebaseAuth.instance;
  FindConfig.storage = FirebaseStorage.instance;
  FindConfig.sharedPreferences = await SharedPreferences.getInstance();

  runApp(const RunApp());
}

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor myColor =
        const MaterialColor(0XFF0b2b1c, FindColors.colorMain);

    return MaterialApp(
      theme: ThemeData(primarySwatch: myColor),
      debugShowCheckedModeBanner: false,
      initialRoute: FindScreens.splashScreen,
      routes: {
        FindScreens.splashScreen: (context) => const SplashScreen(),
        FindScreens.registerScreen: (context) => const registerScreen(),
        FindScreens.loginScren: (context) => const loginScreen(),
        FindScreens.homePage: (context) => const homePage(),
        FindScreens.adminOrUserScreen: (context) => const AdminOrUserScreen(),
        FindScreens.AdminLogin: (context) => const AdminLogin(),
        FindScreens.editProfileUser: (context) => const editProfileUser(),
        FindScreens.lostItems: (context) => const LostItem(),
        FindScreens.userDashbaord: (context) => const userDashbaord(),
        FindScreens.adminDashbaord: (context) => adminDashbaord(),
        FindScreens.foundedItemsAdmin: (context) => const foundedItems(),
        FindScreens.lostItemsAdmin: (context) => const lostItemsAdmin(),
        FindScreens.AdminHome: (context) => const AdminHome(),
        FindScreens.adminProfile: (context) => const adminProfile(),
        FindScreens.editItem: (context) => const editItem(),
        FindScreens.showAdminsToChat: (context) => const showAdminsToChat(),
        FindScreens.allUsers: (context) => const allUsers(),
        FindScreens.feedbackPage: (context) => const feedbackPage(),
        FindScreens.feedbackPageAdmin: (context) => const feedbackPageAdmin(),
        FindScreens.pickedItemsBYTheUser: (context) =>
            const pickedItemsBYTheUser(),
        FindScreens.resetPassword: (context) => resetPassword(),
        FindScreens.adminResetPassword: (context) => adminResetPassword(),
      },
    );
  }
}
