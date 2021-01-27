import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisch_aus_steinbachtal/models/user_model.dart';
import 'package:fisch_aus_steinbachtal/screens/admin_homepage.dart';
import 'package:fisch_aus_steinbachtal/screens/home_page.dart';
import 'package:fisch_aus_steinbachtal/screens/login_page.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/services/user_helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthenticationService>(context);

    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            snapshot.data.isAnonymous
                ? print('Gast ist angemeldet')
                : print('User ' + snapshot.data.email + ' ist angemeldet');

            UserHelper.saveUser(snapshot.data);

            if (snapshot.data.isAnonymous) {
         
              return HomePage(0);
            }

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final userDoc = snapshot.data;
                  final user = userDoc.data();

                  //!!!! UserHelper.userRole = user['role'];
                  auth.appUser = UserModel.fromFirestore(user);

                /*  if (auth.orderInProgress) {
                    auth.orderInProgress = false;
                    return ShoppingBag.makeOrder(null, context);
                  }*/

                  if (user['role'] == 'admin') {
                    return AdminHomePage();
                  } else {
                    return HomePage(0);
                  }
                } else {
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
          return LoginPage();
        });
  }
}
