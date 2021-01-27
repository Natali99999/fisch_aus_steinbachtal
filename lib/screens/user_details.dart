import 'package:fisch_aus_steinbachtal/models/user_model.dart';
import 'package:fisch_aus_steinbachtal/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatelessWidget {
  UserDetails({this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    /* String createdAt = user.devices.length != 0
        ? DateFormat('dd.MM.yyyy  HH:mm:ss').format(
            DateTime.fromMillisecondsSinceEpoch(user.devices[0].createdAt))
        : '';*/

    String lastLogin = DateFormat('dd.MM.yyyy  HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(user.lastLogin));

    return Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          elevation: 0.1,
          backgroundColor: Colors.black,
          title: InkWell(
            child: Text('User Info'),
          ),
        ),
        body:
            /*SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:*/
            Container(
          alignment: Alignment.center,
          height: 600,
          /*decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(20))),*/
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 65,
                  /* decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20))),*/
                  alignment: Alignment.center,
                  child: Column(children: [
                    Text('Name: ${user.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('E-mail: ${user.email}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal)),
                  ])),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Container(
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(width: 1, color: Colors.black),
                    //  borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  // alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*Text("registriert: $createdAt",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal)),*/
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                        Text("zuletzt Online: $lastLogin",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal)),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                        /*  Text("BuildNumber: ${user.buildNumber}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal)),*/
                      ])),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              ),
              deviceListWidget(user),
            ],
          ),
          // ),
        ));
  }

  Widget deviceListWidget(UserModel user) {
    return FutureBuilder<List<Device>>(
        future: OrderServices().getUserDeviceInfo(user.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          List<Device> devices = snapshot.data;
          return Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.black),
                //   borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text("Device info",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black /*AppColors.lightblue*/)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    ),
                    Divider(
                      height: 3,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                              itemCount: devices.length,
                              itemBuilder: (_, index) {
                                String createdAt =
                                    DateFormat('dd.MM.yyyy  HH:mm:ss').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            devices[index].createdAt));
                                String updatedAt =
                                    DateFormat('dd.MM.yyyy  HH:mm:ss').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            devices[index].updatedAt));

                                return Column(children: [
                                  Text('Gerät ID: ${devices[index].id}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                  Text('registriert: $createdAt',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                  Text('Buildnummer: ${user.buildNumber}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                  Text('aktualisiert: $updatedAt',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  ),
                                  Text(
                                      'osVersion: ${devices[index].deviceInfo.osVersion}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                  Text(
                                      'Plattform: ${devices[index].deviceInfo.plattform}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                  Text(
                                      'Model: ${devices[index].deviceInfo.model}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                  Text(
                                      'Gerät: ${devices[index].deviceInfo.device}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                ]);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ]));
        });
  }
}
