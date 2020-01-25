import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_authentication/VerifyPage/landingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Config/config.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   PhoneApp.sharedPreferences = await SharedPreferences.getInstance();
   PhoneApp.auth = FirebaseAuth.instance;
   PhoneApp.firestore = Firestore.instance;
   runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
      home: LandingPage()
    );
  }
}