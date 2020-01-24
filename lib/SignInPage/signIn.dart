import 'package:flutter/material.dart';
import 'OtpScreen.dart';

class SignIn extends StatefulWidget {
  final String verificationId;
  SignIn(this.verificationId);

  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: OtpScreen(verificationID: widget.verificationId,),
      ),
    );
  }
}

