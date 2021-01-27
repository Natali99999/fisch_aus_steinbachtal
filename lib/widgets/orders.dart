import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/provider/my_order_page_provider.dart';
import 'package:fisch_aus_steinbachtal/screens/order_details.dart';
//import 'package:fisch_aus_steinbachtal/screens/user_details.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool sort = false;
  int sortIndex = 2;

  @override
  void initState() {
    // selectedOrders = [];
    sort = false;
    super.initState();
  }

  List<String> orderStatusList = <String>[
    'offen',
    'in Bearbeitung',
    'abholbereit',
    'erledigt'
  ];

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<AuthenticationService>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Bestellungen",
            style: TextStyle(fontSize: 16, color: Colors.black)),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<AllUsersOrdersPageProvider>(
        create: (context) => AllUsersOrdersPageProvider(),
        child: Consumer<AllUsersOrdersPageProvider>(
          builder: (context, provider, child) {
            /*if (provider.users == null) {
              provider.getUsers();
              return Center(child: CircularProgressIndicator());
            }*/
            if (provider.orders == null) {
              provider.getOrders(userService.userId);
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: sort,
                  sortColumnIndex: sortIndex,
                  columns: [
                    DataColumn(
                        label: Text('Details'),
                        tooltip: 'Bestellungsübersicht'),
                    DataColumn(
                        label: Text('Kunde'), tooltip: 'Kunde'),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                            sortIndex = 2;
                          });
                          onSortColum(provider, columnIndex, ascending);
                        },
                        label: Text('Datum'),
                        tooltip: 'Das Datum der Bestellung'),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                            sortIndex = 3;
                          });
                          onSortColum(provider, columnIndex, ascending);
                        },
                        label: Text('Abholdatum'),
                        tooltip: 'Das Datum der Abholung'),
                   /* DataColumn(
                        numeric: false,
                        label: Text('Bestellnr.'),
                        tooltip: 'Bestellnummer'),*/
                    DataColumn(
                        numeric: false,
                        label: Text('Betrag'),
                        tooltip: 'Rechnungsbetrag der Bestellung'),
                    DataColumn(
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                            sortIndex = 5;
                          });
                          onSortColum(provider, columnIndex, ascending);
                        },
                        label: Text('Status'),
                        tooltip: 'Der Status der Bestellung'),
                    
                  ],
                  rows: provider.orders.map((order) {
                    var df = DateFormat('dd.MM.yyyy');
                    String date = df.format(
                        DateTime.fromMillisecondsSinceEpoch(order.createdAt));

                  /*  final foundUser = provider.users != null
                        ? provider.users
                            .where((element) => element.userId == order.userId)
                        : null;
                    String userEmail =
                        foundUser != null ? foundUser.first.email : '';*/

                    return DataRow(cells: [
                      DataCell(IconButton(
                        icon: Icon(Icons.details_outlined,
                            color: AppColors.lightblue),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetails(order: order)));
                        },
                      )),
                      DataCell(Text(order.userName), onTap: () async {
                        /*if (foundUser != null)
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UserDetails(user: foundUser.first)));*/
                      }),
                      DataCell(Text(date.trim())),
                      DataCell(Text(order.terminDate)),
                      
                   //   DataCell(Text(order.orderNr)),
                      DataCell(Text('${order.totalPrice.toString().trim()} €')),
                      DataCell(DropdownButton<String>(
                        value: order.status,
                        onChanged: (String newValue) {
                          setState(() {
                            order.status = newValue;
                            provider.updateOrderStatus(order.id, newValue);
                          });
                        },
                        items: orderStatusList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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

  onSortColum(
      AllUsersOrdersPageProvider provider, int columnIndex, bool ascending) {
    if (columnIndex == 5) {
      if (ascending) {
        provider.orders.sort((a, b) => a.status.compareTo(b.status));
      } else {
        provider.orders.sort((a, b) => b.status.compareTo(a.status));
      }
    } else if (columnIndex == 2 ||columnIndex == 3) {
      if (ascending) {
        provider.orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      } else {
        provider.orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    }
  }

  String getCartItems(List<dynamic> cart) {
    String text2;
    for (int i = 0; i < 1 /*cart.length*/; i++) {
      double sum = cart[i].quantity * cart[i].price;
      String text =
          "${cart[i].name} Price ${cart[i].price} Anzahl ${cart[i].quantity} Gesamt ${sum.toStringAsFixed(2)}";
      text2 += text;
      text2 += '/n';
    }

    return text2;
  }
}
