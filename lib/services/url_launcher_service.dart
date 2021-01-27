import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

//const String phone_number = '+04915779727835';

launchFacebook(String url) async {
 // const url = 'https://www.facebook.com/fischraucherei.ribkin.5';
  _launch(url);
}

launchMapURL(String url) async {
  /*const url =
      'https://www.google.de/maps/dir//Steinbachstra%C3%9Fe+4,+58339+Breckerfeld/@51.2599272,7.4521097,17z/data=!4m8!4m7!1m0!1m5!1m1!1s0x47b9308a4ff436a7:0xd50676db65e0cd1d!2m2!1d7.4543037!2d51.2599272?hl=de';
 */ _launch(url);
}

void launchWhatsApp({@required number, @required message}) async {
  String url = 'whatsapp://send?phone=$number&text=$message';
  await canLaunch(url)
      ? launch(url)
      : print('Whatsapp kann nicht gestartet werden');
}

launchEMAIL(String email, String betreff, String body) async {
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {'subject': betreff, 'body': body},
  );
  _launch(_emailLaunchUri.toString());
}

launchCALL(String phone) async {
   String phonenumber = "tel:$phone";
  _launch(phonenumber);
}

launchSMS(String phone) async {
  String smsPhoneNumber = "sms:$phone";
  _launch(smsPhoneNumber);
}

_launch(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    //Fluttertoast.showToast(msg: "'Could not launch $url");
    throw 'Could not launch $url';
  }
}
