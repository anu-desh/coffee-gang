import 'package:coffeegang/screens/wrapper.dart';
import 'package:coffeegang/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Coffee Gang',
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
