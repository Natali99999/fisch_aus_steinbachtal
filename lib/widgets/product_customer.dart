import 'dart:io';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/screen_navigation.dart';
import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/provider/customer_bloc.dart';
import 'package:fisch_aus_steinbachtal/provider/product_provider.dart';
import 'package:fisch_aus_steinbachtal/screens/edit_product.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductsCustomer extends StatefulWidget {
  @override
  _ProductsCustomerState createState() => _ProductsCustomerState();
}

class _ProductsCustomerState extends State<ProductsCustomer> {
  @override
  Widget build(BuildContext context) {
    var customerBloc = Provider.of<CustomerBloc>(context);
    var userService = Provider.of<AuthenticationService>(context);
  
    double cardHeight = MediaQuery.of(context).size.height / 3 * 1.5;

    return StreamBuilder<List<Product>>(
        stream: customerBloc.fetchAvailableProducts,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: (Platform.isIOS)
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(),
            );
          return Scaffold(
            body: SafeArea(
             // child: Expanded(
               // flex: 1,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: cardHeight + 30,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var product = snapshot.data[index];
                            return getCard(
                                context,
                                product,
                                index,
                                !userService.isCustomer &&
                                    product.vendorId == userService.userId,
                                cardHeight);
                          }),
                    ),
                    if (!userService.isCustomer)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          backgroundColor: AppColors.red,
                          child: Icon(Icons.add, color: Colors.white, size: 15.0),
                          onPressed: () {
                               
                            Navigator.of(context).pushNamed('/editproduct');
                          },
                        ),
                      ),
                  ],
                ),
            //  ),
              //),
            ),
          );
        });
  }
}

Future<bool> _confirmDelete(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Produkt entfernen"),
            content: Text("Wollen Sie des Produkt entfernen?"),
            actions: <Widget>[
              TextButton(
                child: Text("Nein"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text("Ja"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ));
}

getCard(BuildContext context, Product product, int index, bool vendor,
    double height) {
  var gradientColor = GradientTemplate.gradientTemplate[6].colors;
  double width = MediaQuery.of(context).size.width / 3 * 2.0 - 35;

  double imageHeight = height * 0.65;

  double unitPrice = product.units != null && product.units.length > 0
      ? product.units[0].price
      : 0.0;
  String unitType = product.units != null && product.units.length > 0
      ? product.units[0].name
      : '----';

  var productProvider = Provider.of<ProductProvider>(context);
  return Stack(
    children: <Widget>[
      InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed('/product_details/${product.productId}'),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: height,
            width: width,
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColor,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            Text(
                              "${unitPrice.toStringAsFixed(2)} \€/$unitType",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                        SizedBox(width: 10.0)
                      ],
                    ),
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: product.imageUrl.length > 0
                          ? product.imageUrl[0]
                          : '',
                      height: imageHeight,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 25.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            Text(
                              product.productName,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
        //),
      ),
      if (vendor)
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width / 2 - 10, top: height - 20),
              child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: AppColors.straw),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () =>
                          changeScreen(context, EditProduct(product: product)),
                    ),
                  )),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, top: height - 20),
                child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.red),
                    child: Center(
                      child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            if (await _confirmDelete(context)) {
                              productProvider.removeProduct(product.productId);
                            }
                          }),
                    ))),
          ],
        )
      else
        Padding(
          padding: EdgeInsets.only(left: width / 2 - 10, top: height - 20),
          child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: AppColors.lightblue),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.white,
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/product_details/${product.productId}'),
                ),
              )),
        ),
    ],
  );
}
