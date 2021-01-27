import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/form_validator.dart';
import 'package:fisch_aus_steinbachtal/helper/input_deco_design.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
//import 'package:fisch_aus_steinbachtal/services/user_secure_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import '../routes.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name, email, phone = '';


  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

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
  Widget build(BuildContext context) {
     final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side:
                        BorderSide(color: Colors.redAccent, width: 2)),
                ),
  
            onPressed: () {
              if (validate()) {
                context
                    .read<AuthenticationService>()
                    .createAccount(
                      name: nameController.text.trim(),
                      phone: mobileController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    )
                    .then((_) {
                  Navigator.pop(context);

                  Navigator.of(context).pushNamed(AppRoutes.verifyAuthScreen);
                });
              }
            },
        
            child: Text("Registrieren",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0)),
          ),
        ),

        Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: RichText(
              text: TextSpan(
                  text: 'Schon registriert?',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Anmelden',
                      style:
                          TextStyle(color: AppColors.lightblue, fontSize: 18),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed(AppRoutes.authLogin);
                        },
                    )
                  ]),
            ),
          ),
        )

        // ),
      ],
    );

    return Scaffold(
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
                        return 'Bitte den Nachnamen eingeben';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      name = value;
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
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration:
                        buildInputDecoration(Icons.phone, "Handy-/Telefonnummer"),
                    maxLength: 16,
                      validator: (item) {
                            return item.length < 8
                                ? "Ungültige Handy-/Telefonnummer"
                                : null;
                          },
                    onChanged: (String value) {
                      phone = value;
                    },
                  ),
                ),
               Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.lock, "Passwort"),
                    validator: passwordValidator,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    obscureText: true,
                    controller: confirmpasswordController,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(
                        Icons.lock, "Passwort erneut eingeben"),
                    validator: (val) => MatchValidator(
                            errorText: 'Passwörter stimmen nicht überein')
                        .validateMatch(val, passwordController.text),
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
