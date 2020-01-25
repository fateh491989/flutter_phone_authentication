import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_authentication/Config/config.dart';
import 'package:flutter_phone_authentication/Dialogs/errorDialog.dart';
import 'package:flutter_phone_authentication/Dialogs/loadingDialog.dart';
import 'package:flutter_phone_authentication/PersonalInformation/namephoto.dart';
import 'package:flutter_phone_authentication/WIdgets/nextButton.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class OtpScreen extends StatefulWidget {
  final String verificationID;

  const OtpScreen({Key key, this.verificationID}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _smsController = TextEditingController();
  String _message;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Text(
            "Verify ${PhoneApp.sharedPreferences.getString(PhoneApp.userPhoneNumber)}",
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RichText(
                // text: "",
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        "Waiting to automatically detect an SMS sent to Verify ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            "Verify ${PhoneApp.sharedPreferences.getString(PhoneApp.userPhoneNumber)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )
                    ]),
              )

              //Text("Waiting to automatically detect an SMS sent to Verify +91 7973268843",textAlign: TextAlign.center,),
              ),
          Container(
            // height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PinEntryTextField(
                showFieldAsBox: true,
                fields: 6,
                onSubmit: (String pin) {
                  _smsController.text = pin;
                },
              ),
            ),
          ),
          Text(
            "Enter 6-digit code",
            style: TextStyle(color: Colors.grey),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: RedButton(
              title: PhoneApp.signIn,
              screenWidth: _screenWidth * 0.9,
              onTap: _signInWithPhoneNumber,
            ),
          ),
          Flexible(child: Container()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Version 1.0.0'),
            ),
          )
        ],
      ),
    );
  }

  void _signInWithPhoneNumber() async {
    showDialog(
        context: context,
        builder: (_) {
          return LoadingAlertDialog();
        });
    print(widget.verificationID);
    print(_smsController.text);
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: widget.verificationID,
      smsCode: _smsController.text,
    );
    FirebaseUser user;
    await PhoneApp.auth.signInWithCredential(credential).then((u) async {
      user = u.user;
      final FirebaseUser currentUser = await PhoneApp.auth.currentUser();
      assert(user.uid == currentUser.uid);
      if (user != null) {
        _message = 'Successfully signed in, uid: ' + user.uid;
        //TODO
        print(_message);
        // Writing data  to database
        PhoneApp.firestore
            .collection(PhoneApp.collectionUser)
            .document(user.uid)
            .setData({
          PhoneApp.userUID: user.uid,
          PhoneApp.userPhoneNumber:
              PhoneApp.sharedPreferences.getString(PhoneApp.userPhoneNumber),
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => PersonalInfo()));
      } else {
        _message = 'Sign in failed';
      }
    }).catchError((error) {
      print("bh");
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (v) {
            return ErrorAlertDialog(
              message: 'Phone number verification failed.',
            );
          });
    });
  }
}
