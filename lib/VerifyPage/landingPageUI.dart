import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_authentication/Config/config.dart';
import 'package:flutter_phone_authentication/Dialogs/errorDialog.dart';
import 'package:flutter_phone_authentication/Dialogs/loadingDialog.dart';
import 'package:flutter_phone_authentication/PersonalInformation/namephoto.dart';
import 'package:flutter_phone_authentication/SignInPage/signIn.dart';
import 'package:flutter_phone_authentication/VerifyPage/landingPage.dart';
import 'package:flutter_phone_authentication/WIdgets/nextButton.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _countryTextController = TextEditingController(),
      _phoneTextController = TextEditingController();
  final _enterNumberFormKey = GlobalKey<FormState>();
  final _scaffoldState = GlobalKey<ScaffoldState>();
  String _message = '';
  String _verificationId;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Text(
          PhoneApp.signInText,
          style: TextStyle(
              color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          PhoneApp.enterPhoneNumber,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          PhoneApp.sendSMS,
          textAlign: TextAlign.center,
        ),
        Container(
          height: 100,
          width: _screenWidth,
          child: Form(
            key: _enterNumberFormKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  width: _screenWidth * 0.3,
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                    controller: _countryTextController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.add,
                        ),
                        border: OutlineInputBorder()),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Country code (+xxx)';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: _screenWidth * 0.05,
                ),
                Container(
                  height: 60,
                  width: _screenWidth * 0.5,
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.number,
                    controller: _phoneTextController,
                    decoration: const InputDecoration(
                        //hintStyle: TextStyle(fontSize: 12),
                        hintText: 'Phone number'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          PhoneApp.tapButton,
          textAlign: TextAlign.center,
        ),
        Container(
          margin: EdgeInsets.only(top: 50),
          child: RedButton(
              title: PhoneApp.next,
              screenWidth: _screenWidth * 0.9,
              onTap: _verifyPhoneNumber),
        ),
        Flexible(child: Container()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(PhoneApp.version),
          ),
        ),
      ],
    );
  }

  void _verifyPhoneNumber() async {

    if (_countryTextController.text == '') {
    //  Navigator.pop(context);
      showDialog(
          context: context,
          builder: (v) {
            return ErrorAlertDialog(
              message: "Please enter country code",
            );
          });
    } else if (_phoneTextController.text == '') {
      //Navigator.pop(context);
      showDialog(
          context: context,
          builder: (v) {
            return ErrorAlertDialog(
              message: "Please enter phone number",
            );
          });
    } else {
      showDialog(context: context,builder: (_){
        return LoadingAlertDialog();
      });
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) async {
        print("h");
        final FirebaseUser user =
            (await PhoneApp.auth.signInWithCredential(phoneAuthCredential)).user;

        //(await ChatApp.auth.signInWithCredential(credential)).user;
        final FirebaseUser currentUser = await PhoneApp.auth.currentUser();
        assert(user.uid == currentUser.uid);

          if (user != null) {
            _message = 'Successfully signed in, uid: ' + user.uid;
            //TODO
            print(_message);
            print("Landing");
            await PhoneApp.sharedPreferences
                .setString(PhoneApp.userUID, user.uid);
            await PhoneApp.sharedPreferences.setString(PhoneApp.userPhoneNumber,
                "+${_countryTextController.text + _phoneTextController.text}");
            PhoneApp.firestore
                .collection(PhoneApp.collectionUser)
                .document(user.uid)
                .setData({
              PhoneApp.userUID: user.uid,
              PhoneApp.userPhoneNumber: '+${_countryTextController.text + _phoneTextController.text}'
            }).then((_){
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => PersonalInfo()));
            });
            //TODO
            // change peer ID with your ID
          } else {
            _message = 'Sign in failed';
          }

          _message = 'Received phone auth credential: $phoneAuthCredential';
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (v) {
                  return ErrorAlertDialog(
                    message: 'Phone number verification failed.',
                  );
                });
        setState(() {
          _message =
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
          _scaffoldState.currentState.showSnackBar(SnackBar(
            content: Text(_message),
          ));
        });
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        print("g");
        _verificationId = verificationId;
        await PhoneApp.sharedPreferences.setString(PhoneApp.userPhoneNumber,
            "+${_countryTextController.text + _phoneTextController.text}");
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignIn(verificationId)));
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
      };
      print(_countryTextController.text + _phoneTextController.text);
      await PhoneApp.auth.verifyPhoneNumber(
          phoneNumber:
              "+${_countryTextController.text}${_phoneTextController.text}",
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      print(_message);
    }
  }
}