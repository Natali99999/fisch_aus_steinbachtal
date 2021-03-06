import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:package_info/package_info.dart';

class UserHelper {
 /* static User authUser;
  static String userRole = 'guest';

  static bool get isGuest => userRole == 'guest';
  static bool get isAdmin => userRole == 'admin';
  static bool get isVendor => userRole == 'vendor';
  static bool get isCustomer => userRole == 'customer';*/

  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user) async {
   //authUser = user;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
   // int createdAt = user.metadata.creationTime.millisecondsSinceEpoch;

    // register fcm token
   // FirebaseMessaging firebaseMessaging = FirebaseMessaging();
   
   /* Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
      "created_at": createdAt,
      "role": "customer",
      "build_number": buildNumber
    };*/

 
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime.millisecondsSinceEpoch,
        "build_number": buildNumber
      });
      await _saveDevice(user);
    } else {
      //await _db.collection("users").doc(user.uid).set(userData);
    }
   // await _saveDevice(user);
  }

  static _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    String deviceId;
    Map<String, dynamic> deviceData;
    if (Platform.isAndroid) {
      final deviceInfo = await devicePlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await devicePlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "device": deviceInfo.name,
        "model": deviceInfo.utsname.machine,
        "platform": 'ios',
      };
    }
    final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
    final deviceRef = _db
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);

    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMS,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "updated_at": nowMS,
        "uninstalled": false,
        "id": deviceId,
        "created_at": nowMS,
        "device_info": deviceData,
      });
    }
  }
}
