import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatApp{
  static SharedPreferences sharedPreferences;
  static FirebaseUser user;
  static FirebaseAuth auth;
  static Firestore firestore ;

  // Firebase Collection name
  static String collectionUser = "users";
  static String collectionMessage = "messages";


  // App Info
  static String version = 'Version 1.0.0';
  //Strings
  static String signInText = "Sign in using Phone Number";
  static String signIn = "Sign In";
  static String next = "Next";
  static String tapButton  = "Tap Next to verify your account with phone number. "
      "You don`t need to enter verification code manually if number is installed in your phone";
  static String enterPhoneNumber  = "Enter your phone number";
  static String sendSMS  = "We will send an SMS message to verify your phone number.";
  static String enterName  = "Enter your name";
  static String done  = "Done";
//  static String enterPhoneNumber  = "Enter your phone number";
//  static String enterPhoneNumber  = "Enter your phone number";
//  static String enterPhoneNumber  = "Enter your phone number";
//  static String enterPhoneNumber  = "Enter your phone number";
//  static String enterPhoneNumber  = "Enter your phone number";
//  static String enterPhoneNumber  = "Enter your phone number";



 // User Detail
  static final String userName = 'name';
  static final String userPhoneNumber = 'phoneNumber';
  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userLastSeen = 'lastseen';
  static final String isTyping = 'isTyping';
  static final String isOnline = 'isOnline';
}
