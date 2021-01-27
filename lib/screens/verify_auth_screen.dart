import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../routes.dart';

class VerifyAuthScreen extends StatefulWidget {
  @override
  _VerifyAuthScreenState createState() => _VerifyAuthScreenState();
}

class _VerifyAuthScreenState extends State<VerifyAuthScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            "Eine E-Mail wurde an ${user.email}\ngesendet. Bitte überprüfen sie"),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();

      Navigator.of(context)
          .pushReplacementNamed(AppRoutes.homepage, arguments: user.uid);
    }
  }
}
