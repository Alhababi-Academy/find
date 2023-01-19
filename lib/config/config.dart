import 'package:find/AdminHome/adminHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindConfig {
  static const appName = 'appName';
  static const userName = 'userName';
  static const userEmial = 'userEmail';
  static const userImage = 'userImage';
  static const adminUserName = 'adminUser';

  static FirebaseAuth? auth;
  static FirebaseStorage? storage;
  static FirebaseFirestore? firestore;
  static SharedPreferences? sharedPreferences;
}

class FindColors {
  static const Color primaryColor = Color(0XFF0b2b1c);
  static const Color secondaryColor = Color(0XFFcbdbd6);
  static const Color textColor = Color(0XFF2b5245);
  static const Color textColor2 = Color(0XFF4c5c54);
  static const Color appColor = Color(0XFF8c948c);

  static const colorMain = {
    50: Color.fromRGBO(11, 43, 28, 1),
    100: Color.fromRGBO(11, 43, 28, 1),
    200: Color.fromRGBO(11, 43, 28, 1),
    300: Color.fromRGBO(11, 43, 28, 1),
    400: Color.fromRGBO(11, 43, 28, 1),
    500: Color.fromRGBO(11, 43, 28, 1),
    600: Color.fromRGBO(11, 43, 28, 1),
    700: Color.fromRGBO(11, 43, 28, 1),
    800: Color.fromRGBO(11, 43, 28, 1),
    900: Color.fromRGBO(11, 43, 28, 1),
  };
}

class FindScreens {
  static const splashScreen = "/";
  static const loginScren = "/login";
  static const registerScreen = "/register";
  static const homePage = "/homePage";
  static const adminOrUserScreen = '/adminOrUserScreen';
  static const AdminLogin = '/AdminLogin';
  static const adminDashbaord = '/AdminDashbaord';
  static const editProfileUser = '/editProfileUser';
  static const lostItems = '/lostItems';
  static const chat = '/chat';
  static const userDashbaord = '/userDashbaord';
  static const adminProfile = '/adminProfile';
  static const foundedItemsAdmin = '/foundedItemsAdmin';
  static const lostItemsAdmin = '/lostItemsAdmin';
  static const AdminHome = '/AdminHome';
  static const editItem = '/editItem';
  static const showAdminsToChat = '/showAdminsToChat';
  static const allUsers = '/allUsers';
  static const feedbackPage = '/feedbackPage';
  static const feedbackPageAdmin = '/feedbackPageAdmin';
  static const pickedItemsBYTheUser = '/pickedItemsBYTheUser';
  static const resetPassword = '/resetPassword';
  static const adminResetPassword = '/adminResetPassword';
}
