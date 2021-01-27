import 'package:fisch_aus_steinbachtal/models/contact.dart';
import 'package:fisch_aus_steinbachtal/services/firestore_services.dart';

class ContactDataServices {
  static final ContactDataServices _instance = ContactDataServices.internal();

  factory ContactDataServices() {
    return _instance;
  }

  ContactDataServices.internal() {
   // _getContactData();
  }

  ContactData _contactData;
  final FirestoreService _firestoreService = FirestoreService();

  Future<ContactData> getContactData() async {
    if (_contactData == null) {
      _contactData = await _firestoreService.getContactData();
    }
    return Future.value(_contactData);
  }

  String emailFrom() {
      return _contactData.email;
  
  }

  String emailPsw() {
      return _contactData.emailPwd;
    
  }
}
