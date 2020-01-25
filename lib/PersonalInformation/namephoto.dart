import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_authentication/Config/config.dart';
import 'package:flutter_phone_authentication/VerifyPage/landingPage.dart';
import 'package:image_picker/image_picker.dart';

import '../Dialogs/errorDialog.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  @override
  Widget build(BuildContext context) {
    return PersonalInfoScreen();
  }
}

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
                'Signed in ${PhoneApp.sharedPreferences.getString(PhoneApp.userPhoneNumber)}'),
            RaisedButton(
              onPressed: _signOut,
              child: Text('Signout'),
            )
          ],
        ),
      )),
    );
  }

  void _signOut() {
    PhoneApp.auth.signOut().then((_) {
      print('Signed Out Successfully');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (builder) => LandingPage()));
    });
  }
}
