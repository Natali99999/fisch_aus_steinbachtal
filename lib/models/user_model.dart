import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceInfo {
  String osVersion;
  String plattform;
  String model;
  String device;

  DeviceInfo(this.osVersion, this.plattform, this.model, this.device);

  Map<String, dynamic> toMap() {
    return {
      'os_version': osVersion,
      'plattform': plattform,
      'model': model,
      'device': device,
    };
  }

  DeviceInfo.fromFirestore(Map<String, dynamic> firestore) {
    osVersion = firestore['os_version'];
    plattform = firestore['platform'];
    model = firestore['model'];
    device = firestore['device'];
  }

  DeviceInfo.fromSnapshot(DocumentSnapshot snapshot) {
    osVersion = snapshot.data()['os_version'];
    plattform = snapshot.data()['platform'];
    model = snapshot.data()['model'];
    device = snapshot.data()['device'];
  }
}

class Device {
  int createdAt;
  int updatedAt;
  bool uninstalled;
  String id;

  DeviceInfo deviceInfo;

  Device(this.id, this.createdAt, this.updatedAt, this.uninstalled,
      this.deviceInfo);

  Device.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data()['id'];
    createdAt = snapshot.data()['created_at'];
    updatedAt = snapshot.data()['updated_at'];
    uninstalled = snapshot.data()['uninstalled'];
    deviceInfo = DeviceInfo.fromFirestore(snapshot.data()['device_info']);
  }
}

class UserModel {
 
  String name;
  String phone;
  String email;
  String userId;
  String role = 'customer';
  int lastLogin;
  int createdAt;
  int buildNumber;
  List<Device> devices = [];

  UserModel({this.userId, this.name, this.email, this.phone, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'email': email,
      'phone': phone,
      'role': role,
      'last_login': lastLogin,
      'created_at': createdAt,
    };
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.data()['name'];
    phone = snapshot.data()['phone'];
    email = snapshot.data()['email'];
    userId = snapshot.data()['userId'];
    role = snapshot.data()['role'];
    lastLogin = snapshot.data()['last_login'];
    createdAt = snapshot.data()['created_at'];
    buildNumber = snapshot.data()['buildNumber'];
  }

  UserModel.fromFirestore(Map<String, dynamic> firestore) {
    userId = firestore['userId'];
    email = firestore['email'];
    name = firestore['name'];
    phone = firestore['phone'];
    role = firestore['role'];
    lastLogin = firestore['last_login'];
    createdAt = firestore['created_at'];
    buildNumber = firestore['buildNumber'];
  }

}
