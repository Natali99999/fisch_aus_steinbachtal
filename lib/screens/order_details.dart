import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/models/order.dart';
import 'package:fisch_aus_steinbachtal/services/url_launcher_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatelessWidget {
  OrderDetails({this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('dd.MM.yyyy  HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(order.createdAt));
    return Scaffold(
       bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: FaIcon(
                      Icons.phone,
                      color: AppColors.lightblue,
                    ),
                    onPressed: () {
                      launchCALL(order.userMobile);
                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.whatsappSquare,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      launchWhatsApp(
                          number: order.userMobile,
                          message: '');
                    },
                  ),
                
                  IconButton(
                    icon: FaIcon(
                      Icons.email,
                      color: AppColors.lightblue,
                    ),
                    onPressed: () {
                      launchEMAIL(order.userEmail, 'Die Bestellung ist abholbereit', '');
                    },
                  ),
                ]),
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.black,
          title: InkWell(
            child: Text('Meine Bestellungen'),
          ),
        ),
        body: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              height: 700,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      height: 65,
                      alignment: Alignment.center,
                      child: Column(children: [
                        Text('Bestellnummer: ${order.orderNr}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Status: ${order.status}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal)),
                      ])),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                      height: 270,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${order.userName}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.normal)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            ),
                            Text("E-Mail: ${order.userEmail}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.normal)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            ),
                            Text("Telefonnummer: ${order.userMobile}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.normal)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            ),
                            Text("Kommentar: ${order.comment}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.normal)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            ),
                            Text("Bestelldatum: $date",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.normal)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            ),
                            Text(
                                'Abholtermin: ${order.terminDate} ${order.terminTime} Uhr',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.normal)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            ),
                            Text("Rechnungsbetrag: ${order.totalPrice} \€",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.normal)),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            ),
                            Text("Bezahlung: bei Abholung",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.normal)),
                           
                         
                          ])),
                 
                  SizedBox(
                    height: 10,
                  ),
                  orderListWidget(order),
                ],
              ),
            ),
         ],
        )
        );
  }

  Widget orderListWidget(OrderModel order) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black),
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
                    "Bestellungsübersicht (${order.cart.length} Artikel)",
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
                            ' ${order.cart[index].quantity} ${order.cart[index].productUnit.text}'),
                        leading: CircleAvatar(
                          backgroundImage: (order.cart[index].image != null)
                              ? NetworkImage(order.cart[index].image)
                              : AssetImage('assets/images/fish1.png'),
                          radius: 25.0,
                        ),
                        trailing: Text(
                            '${order.cart[index].quantity * order.cart[index].productUnit.price} €'),
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
}
