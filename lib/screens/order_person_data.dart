//import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/input_deco_design.dart';
import 'package:fisch_aus_steinbachtal/models/order.dart';
import 'package:fisch_aus_steinbachtal/screens/order_config_page2.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/services/user_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class OrderPersonDataPage extends StatefulWidget {
  @override
  _OrderPersonDataPageState createState() => _OrderPersonDataPageState();
}

class _OrderPersonDataPageState extends State<OrderPersonDataPage> {
  // final SecureStorage _storage = SecureStorage();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validate() {
    if (formKey.currentState.validate()) {
      print("validated");
      return true;
    } else {
      print("not validated");
      return false;
    }
  }

  @override
  void initState() {
    /* var order = context.flow<OrderModel>().state;
    emailController.text = order.userEmail;
    nameController.text = order.userName;
    mobileController.text = order.userMobile;*/
  

    /*  _storage.email.then((value) {
        emailController.text = value;
      });
      _storage.name.then((value) {
        nameController.text = value;
      });

      _storage.phone.then((value) {
        mobileController.text = value;
      });*/

    super.initState();
  }

  void handleFlow() {
    context.flow<OrderModel>().update((order) => order.copyWith(
        userName: nameController.text,
        userMobile: mobileController.text,
        userEmail: emailController.text));
  }

  @override
  Widget build(BuildContext context) {

    var userService = Provider.of<AuthenticationService>(context);

   // String email, name, phone;
    if (userService.isGuest) {
      final SecureStorage _storage = SecureStorage();
      _storage.email.then((value) {
        emailController.text = value;
      });
      _storage.name.then((value) {
        nameController.text = value;
      });

      _storage.phone.then((value) {
        mobileController.text = value;
      });
    }
    else{
       nameController.text=userService.name;
       emailController.text=userService.email;
       mobileController.text=userService.phone;
    }
    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            child: Text("Weiter",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0)),
            style: ElevatedButton.styleFrom(
              primary: AppColors.lightblue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(color: AppColors.lightblue, width: 2)),
            ),
            onPressed: () {
              if (validate()) {
                handleFlow();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderConfigPage2()));
              }
            },
          ),
        ),

        // ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
          leading: BackButton(onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage(3)));
            // context.flow<OrderFlow>().complete((_) => null);
          }),
          title: Text('Persönliche Daten')),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.person, "Vorname Nachname"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Bitte den Namen eingeben';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      SecureStorage().setName(value);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: buildInputDecoration(Icons.email, "E-Mail"),
                    validator: MultiValidator([
                      // RequiredValidator(errorText: "Required"),
                      EmailValidator(errorText: "Ungültige E-Mail-Adresse")
                    ]),
                    onChanged: (String value) {
                      SecureStorage().setEmail(value);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration:
                        buildInputDecoration(Icons.phone, "Handynummer"),
                    maxLength: 16,
                    validator: (item) {
                      return item.length < 8
                          ? "Ungültige Handy-/Telefonnummer"
                          : null;
                    },
                    onChanged: (String value) {
                      SecureStorage().setPhone(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
