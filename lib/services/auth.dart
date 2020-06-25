import 'package:coffeegang/models/user.dart';
import 'package:coffeegang/screens/authenticate/register.dart';
import 'package:coffeegang/services/database.dart';
import 'package:coffeegang/shared/constants.dart';
import 'package:coffeegang/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //user obj based on firebase
  User _userFormFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFormFirebaseUser);
    //.map((FirebaseUser user) => _userFormFirebaseUser(user));
  }

//  signIn anom
  Future signInAnom() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFormFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//  signIn with email and password
  Future signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFormFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//  register with email and password
  Future registerWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      //create new document for user
      await DatabaseService(uid: user.uid)
          .updateUserData('0', 'new member', 100);
      return _userFormFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with phone
  Future registerWithPhone(String phone, BuildContext context) async {
    bool verified = false;
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) {
          verified = true;
          _auth
              .signInWithCredential(credential)
              .then((AuthResult result) async {
            FirebaseUser user = result.user;
            print(user.uid);
            await DatabaseService(uid: user.uid)
                .updateUserData('0', 'new member', 100);
            return _userFormFirebaseUser(user);
          });
        },
        verificationFailed: (AuthException exception) {
          print('wrong phone number');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Register()));
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          String otp;
          AuthCredential _credential;
          TextEditingController codeController = TextEditingController();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('Enter the OTP'),
              content: TextField(
                controller: codeController,
                decoration: textInputDecoration.copyWith(hintText: 'OTP'),
              ),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    otp = codeController.text.trim();
                    _credential = PhoneAuthProvider.getCredential(
                        verificationId: verificationId, smsCode: otp);
                    _auth
                        .signInWithCredential(_credential)
                        .then((AuthResult result) async {
                      FirebaseUser user = result.user;
                      await DatabaseService(uid: user.uid)
                          .updateUserData('0', 'new member', 100);
                      Navigator.of(context).pop();
                      return _userFormFirebaseUser(user);
                    });
                  },
                ),
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print('time out');
          if (!verified)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Register()));
        },
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//  sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
