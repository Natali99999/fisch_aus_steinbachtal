import 'package:animations/animations.dart';
import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/models/order.dart';
import 'package:fisch_aus_steinbachtal/screens/pdf_screen.dart';

import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';

import 'order_config_page2.dart';

class OrderFinalPage extends StatefulWidget {
  @override
  _OrderFinalPageState createState() => _OrderFinalPageState();
}

class _OrderFinalPageState extends State<OrderFinalPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool agb = false;
  bool validate() {
    if (formKey.currentState.validate()) {
      print("validated");
      return true;
    } else {
      print("not validated");
      return false;
    }
  }

  Widget orderListWidget() {
    var order = context.flow<OrderModel>().state;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 3.0,
              color: AppColors.lightblue.withOpacity(0.2),
              spreadRadius: 4.0)
        ],
        color: Colors.white,
        //border: Border.all(width: 1, color: Colors.black),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                    "Bestelungsnummer: ${order.orderNr} (${order.cart.length} Artikel)",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
          ),
          Divider(
            height: 3,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: order.cart.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Text(order.cart[index].name),
                        subtitle: Text(
                            ' ${order.cart[index].quantity} x ${order.cart[index].productUnit.name}'),
                        leading: CircleAvatar(
                          backgroundImage: (order.cart[index].image != null)
                              ? NetworkImage(order.cart[index].image)
                              : AssetImage(Base.placeholderImage),
                          radius: 25.0,
                        ),
                        trailing: Text(
                            '${(order.cart[index].quantity * order.cart[index].productUnit.price).toStringAsFixed(2)} €'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleFlow() {
    context.flow<OrderModel>().complete((order) => order.copyWith(agb: agb));
  }

  @override
  Widget build(BuildContext context) {
    var order = context.flow<OrderModel>().state;
    // var cartProvider = Provider.of<CartProvider>(context);

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
              child: Text("Bestellung abschicken",
                  style:
                      TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0)),
              style: ElevatedButton.styleFrom(
                primary: AppColors.red,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(color: AppColors.red, width: 2)),
              ),
              onPressed: () async {
                if (!agb) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Sie müssen die Nutzungsbedingungen akzeptieren'),
                    ),
                  );

                  return;
                }

                if (validate()) {
                  handleFlow();
                  // Navigator.of(context).pop();
                  // Navigator.of(context).popUntil((route) => route.isFirst);

                }
              },
            ),
          ),
        ),

        // ),
      ],
    );

    return Scaffold(
        appBar: AppBar(
            leading: BackButton(onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OrderConfigPage2()));
              //context.flow<OrderFlow>().complete((_) => null);
            }),
            title: Text('Bestellungsübersicht')),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),

                  // Bestellungsübersicht
                  orderListWidget(),

                  Padding(
                    padding: EdgeInsets.all(5),
                  ),

                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3.0,
                            color: AppColors.lightblue.withOpacity(0.2),
                            spreadRadius: 4.0)
                      ],
                      color: Colors.white,
                      // border: Border.all(width: 1, color: Colors.black),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Rechnungsbetrag",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text("${order.totalPrice.toStringAsFixed(2)} €",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Barzahlung bei Abholung",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize:
                                      16 /*,
                                        fontWeight: FontWeight.bold*/
                                  )),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 135,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3.0,
                              color: AppColors.lightblue.withOpacity(0.2),
                              spreadRadius: 4.0)
                        ],

                        color: Colors.white,
                        // border: Border.all(width: 1, color: Colors.black),
                      ),
                      padding: EdgeInsets.all(10),
                      child: FormField<bool>(
                        builder: (state) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                      value: agb,
                                      onChanged: (value) {
                                        setState(() {
                                          agb = value;
                                          state.didChange(value);
                                        });
                                      }),
                                  // Ich erkläre mich mit den\nNutzungsbedingungen einverstande
                                  //Text(Base.agbText),

                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: "Ich erkläre mich mit den\n",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      children: [
                                        TextSpan(
                                          text: "Nutzungsbedingungen\n",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              showModal(
                                                context: context,
                                                configuration:
                                                    FadeScaleTransitionConfiguration(),
                                                builder: (context) {
                                                  return MarkdownPage(
                                                      storageFilename: Base
                                                          .agbStorageFilename);

                                                  /*PolicyDialog(
                                                      mdFileName: 'terms_and_conditions.md',
                                                    );*/
                                                },
                                              );
                                            },
                                        ),
                                        TextSpan(
                                            text:
                                                "einverstanden.\nBitte beachten Sie zudem unsere\n"),
                                        TextSpan(
                                          text: "Datenschutzhinweise\n",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return MarkdownPage(
                                                      storageFilename: Base
                                                          .datenschutzStorageFilename);
                                                  /* PolicyDialog(
                                                      mdFileName: 'privacy_policy.md',
                                                    );*/
                                                },
                                              );
                                            },
                                        ),
                                        TextSpan(
                                            text: "für die Nutzung der App."),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                state.errorText ?? '',
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                              )
                            ],
                          );
                        },
                        validator: (value) {
                          // Sie müssen die Nutzungsbedingungen akzeptieren
                          if (!agb) {
                            return Base.agbText2;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: bottom,
                  ),
                ],
              ),
            ))));

    //),
  }
}
