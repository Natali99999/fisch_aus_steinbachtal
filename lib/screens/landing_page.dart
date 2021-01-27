//import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
//import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/text.dart';
import 'package:fisch_aus_steinbachtal/models/contact.dart';
import 'package:fisch_aus_steinbachtal/routes.dart';
//import 'package:fisch_aus_steinbachtal/services/contact_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ContactData contactData = Provider.of<ContactData>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image(image: AssetImage('assets/images/logo.png')),
          ),
          Column(
            children: <Widget>[

              SizedBox(height: 30.0),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(5.0, 5.0),
                            blurRadius: 5.0)
                      ]),
                  margin: EdgeInsets.only(top:38.0, left:35, right:35, bottom: 38),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: /*AssetImage(
                                      Base.logo)*/
                                     NetworkImage( contactData.logo) ,
                                   fit: BoxFit.fill),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              )),
                        ),
                      ),
                      SizedBox(height: 20.0),
                     /* Text(
                        "Herzlich Willkommen",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 22.0,
                        ),
                      ),*/
                       Text(
                        contactData != null ? contactData.logoText :'unknown logo',
                        style: TextStyles.logoStyle,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        contactData != null ? contactData.landingText :'',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14.0),
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                width: double.infinity,
                child: ElevatedButton(
                 /* padding: const EdgeInsets.all(16.0),*/
             
                  style: ElevatedButton.styleFrom(
                      primary:  AppColors.lightblue,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                    ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.auth_wrapper);
                  },
                  child: Text(
                    "Jetzt  einkaufen",
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
            ],
          )
        ],
      ),
    );
  }
}
