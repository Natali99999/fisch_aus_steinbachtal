import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/form_validator.dart';
import 'package:fisch_aus_steinbachtal/helper/input_deco_design.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/services/user_secure_storage.dart';

import 'package:fisch_aus_steinbachtal/widgets/terms_of_use.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import '../routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SecureStorage _storage = SecureStorage();

  TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  final Pattern _emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
    _storage.readSecureData('email').then((value) {
      emailController.text = value;
    });
    //passwordController.text = UserPreferences().password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var provider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Anmelden"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 25.0, right: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                //  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child:
                        /*Column(
                      children: [
                        CircleAvatar(radius: 50,
                              backgroundImage: AssetImage(Base.logo)),
                      ],*/
                        Text('Ich bin bereits Kunde',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center),
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: buildInputDecoration(Icons.email, "E-Mail"),
                      validator: MultiValidator([
                        PatternValidator(_emailPattern,
                            errorText:
                                "Bitte geben Sie eine gültige E-Mail-Adresse ein")
                        /* EmailValidator(
                            errorText:
                                "Bitte geben Sie eine gültige E-Mail-Adresse ein")*/
                      ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20, bottom: 5),
                    child: Container(
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              AppRoutes.forgotPswScreen,
                              arguments: emailController.text.trim());
                        },
                        child: Text("Passwort vergessen?",
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.right),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Passwort",
                        hintText: "Passwort",
                        prefixIcon: Icon(Icons.lock),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide:
                              BorderSide(color: Colors.green, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: AppColors.lightblue,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: AppColors.lightblue,
                            width: 1.5,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _toggleObscureText,
                        ),
                      ),
                      validator: passwordValidator,
                    ),
                  ),

                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (validate()) {
                          context
                              .read<AuthenticationService>()
                              .signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              )
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value),
                              ),
                            );
                            Navigator.pop(context);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.lightblue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(
                                color: AppColors.lightblue, width: 2)),
                      ),
                      child: Text(
                        "Anmelden",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 18.0),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Kein Konto?',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Registrieren \n\n',
                                    style: TextStyle(
                                        color: AppColors.lightblue,
                                        fontSize: 18),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushNamed(AppRoutes.authRegister);
                                      })
                              ]),
                        ),
                      )),

                  // if(!UserHelper.isGuest)
                  SizedBox(
                    width: 280,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                    
                          context
                              .read<AuthenticationService>()
                              .doAnonymousLogin()
                              .then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(value)));
                          });
                        
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(
                                color: AppColors.lightgray, width: 2)),
                      ),
                      child: Text(
                        "ohne Registierung",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 18.0),
                      ),
                    ),
                  ),
                  TermsOfUse()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
