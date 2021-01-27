import 'package:cloud_firestore/cloud_firestore.dart';

class ContactData {
  String name;
  String firstname;
  String town;
  String street;
  String homeNr;
  String visitingcartPhoto;
  String logo;
  String mapUrl;
  String facebookUrl;
  String facebook;
  String email;
  String firma;
  String firma2;
  String postCode;
  String mobilePhone;
  String whatsApp;
  String emailPwd;
  GeoPoint geopoint;
  String pageFishPlatesText;
  String pageCelebrationText;
  String pageCelebrationText2;
  String logoText;
  String landingText;

  ContactData();

  /* Map<String, dynamic> toMap() {
    return {
      'email': email,
      'facebook': facebook,
      'facebook_url': facebookUrl,
      'firma': firma,
      'firma2': firma2,
      'logo': logo,
      'map_url': mapUrl,
      'person_nachname': name,
      'person_name': firstname,
      'plz': postCode,
      'stadt': town,
      'straße': street,
      'telefon': mobilePhone,
      'visitenkarten_foto': visitingcartPhoto,
      'whatsapp': whatsApp,
      'hausNr': homeNr,
      'email_password': emailPwd,
    };
  }*/


  ContactData.fromSnapshot(DocumentSnapshot snapshot) {
    email = snapshot.data()['email'];
    facebook = snapshot.data()['facebook'];
    facebookUrl = snapshot.data()['facebook_url'];
    firma = snapshot.data()['firma'];
    firma2 = snapshot.data()['firma2'];
    logo = snapshot.data()['logo'];
    mapUrl = snapshot.data()['map_url'];
    name = snapshot.data()['person_nachname'];
    firstname = snapshot.data()['person_name'];
    postCode = snapshot.data()['plz'];
    town = snapshot.data()['stadt'];
    street = snapshot.data()['straße'];
    mobilePhone = snapshot.data()['telefon'];
    visitingcartPhoto = snapshot.data()['visitenkarten_foto'];
    homeNr = snapshot.data()['hausNr'];
    whatsApp = snapshot.data()['whatsapp'];
    emailPwd = snapshot.data()['email_password'];
    geopoint = snapshot.data()['geopoint'];
    logoText = snapshot.data()['logo_text'];
    pageFishPlatesText = snapshot.data()['pageFishPlatesText'];
    pageCelebrationText = snapshot.data()['pageCelebrationText'];
    pageCelebrationText2 = snapshot.data()['pageCelebrationText2'];
    landingText = snapshot.data()['landingText'];

    landingText = landingText.replaceAll('\\n', '\n');
    pageFishPlatesText = pageFishPlatesText.replaceAll('\\n', '\n');
    pageCelebrationText = pageCelebrationText.replaceAll('\\n', '\n');
    pageCelebrationText2 = pageCelebrationText2.replaceAll('\\n', '\n');
  }
}
