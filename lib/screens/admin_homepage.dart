import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisch_aus_steinbachtal/widgets/navigateDrawer.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Homepage'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final docs = snapshot.data.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = docs[index].data();
                        return ListTile(
                          title: Text(user['name'] ?? 'ohne Name'),
                          subtitle: Text(user['email']),
                          leading: (user['role'] == "vendor")
                              ? Icon(Icons.shopping_bag)
                              : (user['role'] == "admin")
                                  ? Icon(Icons.admin_panel_settings_outlined)
                                  : Icon(Icons.person),
                          //trailing: Text(user['userId']),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              /*  ElevatedButton(
              child: Text("Log out"),
              onPressed: () {
                AuthHelper.logOut();
              },
            )*/
            ],
          ),
        ),
        drawer: NavigateDrawer());
  }
}
