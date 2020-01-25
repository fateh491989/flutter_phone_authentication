import 'package:flutter/material.dart';
import 'package:flutter_phone_authentication/Config/config.dart';
import 'package:flutter_phone_authentication/PersonalInformation/namephoto.dart';
import 'package:flutter_phone_authentication/VerifyPage/landingPageUI.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}
class _LandingPageState extends State<LandingPage> {

  @override
  void initState() {
    super.initState();
    readLocal();

  }
  readLocal() async {
    if(await PhoneApp.auth.currentUser()!= null){
      Route route = MaterialPageRoute(
          builder: (builder) => PersonalInfo());
      Navigator.push(context, route);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PhoneAuthScreen(),
      ),
    );
  }
}

