import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/input_deco_design.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({this.email});
  final String email;
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Passwort zurücksetzen"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                      "Wir werden Ihnen einen Link senden ... Bitte klicken Sie auf diesen Link, um Ihr Passwort zurückzusetzen",
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: buildInputDecoration(Icons.email, "E-Mail"),
                      validator: MultiValidator([
                         EmailValidator(
                            errorText: "Bitte geben Sie eine gültige E-Mail-Adresse ein")
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          bool hasError = false;
                          context
                              .read<AuthenticationService>()
                              .sendPasswordResetEmail(
                                email: emailController.text.trim(),
                              )
                              .catchError((onError) {
                            showMessage(onError.toString());
                            hasError = true;
                          }).then((value) {
                            if (!hasError) {
                              var msg =
                                  'Reset-E-Mail erfolgreich gesendet! Überprüfen Sie Ihren Posteingang und folgen Sie den Anweisungen.';
                              showMessage(msg);
                            }
                          });
                        }
                        // Navigator.of(context).pushNamed(AppRoutes.authRegister);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.lightblue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.blue, width: 2)),
                      ),
                    
                      child: Text("E-Mail senden"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showMessage(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text("Error"),
            content: Text(msg),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
