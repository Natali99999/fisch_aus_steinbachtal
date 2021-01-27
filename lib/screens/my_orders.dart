import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/provider/my_order_page_provider.dart';
import 'package:fisch_aus_steinbachtal/screens/order_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatelessWidget {
  MyOrdersScreen({this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: InkWell(
          child: Text('Meine Bestellungen'),
        ),
      ),
      body: ChangeNotifierProvider<MyOrderPageProvider>(
        create: (context) => MyOrderPageProvider(),
        child: Consumer<MyOrderPageProvider>(
          builder: (context, provider, child) {
            if (provider.orders == null) {
              provider.getOrders(uid);
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text('Datum'),
                        tooltip: 'Das Datum der Bestellung'),
                    DataColumn(
                        label: Text('Betrag'),
                        tooltip: 'Rechnungsbetrag der Bestellung'),
                    /*  DataColumn(
                        label: Text('Status'),
                        tooltip: 'Der Status der Bestellung'),*/
                    DataColumn(
                        label: Text('Details'),
                        tooltip: 'represents phone number of the user'),
                  ],
                  rows: provider.orders.map((order) {
                    var df = DateFormat('dd.MM.yyyy');
                    String date = df.format(
                        DateTime.fromMillisecondsSinceEpoch(order.createdAt));

                    return DataRow(
                        cells: [
                          DataCell(Text(date.trim())),
                          DataCell(
                              Text('${order.totalPrice.toString().trim()} €')),
                          //  DataCell(Text(order.status.trim())),
                          DataCell(IconButton(
                            icon: Icon(Icons.arrow_forward,
                                color: AppColors.lightblue),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetails(order: order)));
                            },
                          )),
                        ]);
                  }).toList(),
                ),
              ),
              //  ),
              // ),
            );
          },
        ),
      ),
    );
  }
}
