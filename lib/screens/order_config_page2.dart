import 'dart:math';

//import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/input_deco_design.dart';
import 'package:fisch_aus_steinbachtal/models/order.dart';

import 'package:fisch_aus_steinbachtal/screens/order_final_page.dart';
import 'package:fisch_aus_steinbachtal/widgets/date_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';

import 'order_person_data.dart';

class OrderConfigPage2 extends StatefulWidget {
  @override
  _OrderConfigPage2State createState() => _OrderConfigPage2State();
}

class _OrderConfigPage2State extends State<OrderConfigPage2> {
  String comment;
  Termin termin;

  String orderNr;

  @override
  void initState() {
    super.initState();
    var rng = new Random();
    orderNr = rng.nextInt(100).toString();
    termin = Termin();
  }

  final TextEditingController commentController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<bool> _confirmDateTime(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              //  title: Text("Abholdatum/-Uhrzeit"),
              content: Text("Bitte wählen Sie Abholdatum/-Uhrzeit aus?"),
              actions: <Widget>[
                TextButton(
                  child: Text("ok"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: Text("ohne weiter"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
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

  void handleFlow() {
    context.flow<OrderModel>().update((order) => order.copyWith(
        comment: comment,
        terminDate: termin.date,
        terminTime: termin.time,
        orderNr: orderNr));
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
            child: Text("Bestellung prüfen",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0)),
            style: ElevatedButton.styleFrom(
                  primary:  AppColors.lightblue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side:
                              BorderSide(color: AppColors.lightblue, width: 2)),
                      ),
       
            onPressed: () async {
              bool result = true;
              if (validate()) {
                if ((termin.date == null) || (termin.time == null)) {
                   result = await _confirmDateTime(context);
                }
                
                if (result) {
                  handleFlow();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderFinalPage()));
                }
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
           
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderPersonDataPage()));
          }),
          title: Text('Lieferung')),
      body: //Center(
          /*child:*/ Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text:
                          "z.Z. nur Abholung möglich,\nLieferung nur bei größeren Bestellung\n (nach Veranbahrung) möglich.\n\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  /* TextSpan(
                            text:
                                "\n(Schreiben Sie in das Kommentarfeld)\n\n",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),*/
                  TextSpan(
                      text: "Adresse:",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: " Fischräucherei\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300)),
                  TextSpan(
                      text: "                 Steinbach 4B\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300)),
                  TextSpan(
                      text: "                 58339 Breckerfeld\n",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300)),
                ])),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Wählen Sie den Abholtermin aus",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                ),
                Divider(
                  height: 3,
                  color: Colors.black,
                ),
                DateTimeWidget(
                    termin: termin,
                    createdAt: context.flow<OrderModel>().state.createdAt
                    /*order: context.flow<OrderModel>().state*/),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    maxLines: 2,
                    controller: commentController,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.note, "Kommentar"),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    onChanged: (String value) {
                      comment = value;
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
      //),
    );
  }
}
