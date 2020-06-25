import 'package:coffeegang/screens/authenticate/register.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthenticateState();
  }
}

class AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn)
      return SignIn(toggleView: toggleView);
    else
      return Register(toggleView: toggleView);
  }
}
