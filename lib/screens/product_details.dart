import 'package:expandable_widget/res/expandable_text.dart';
import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/text.dart';
import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/provider/cart_provider.dart';
import 'package:fisch_aus_steinbachtal/provider/product_provider.dart';
import 'package:fisch_aus_steinbachtal/routes.dart';
//import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/widgets/button.dart';
import 'package:fisch_aus_steinbachtal/widgets/image_swipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  ProductDetails({this.productId});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  ProductUnit selectedUnit;
  int selectedUnitIndex = 0;
  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    var cartProvider = Provider.of<CartProvider>(context);

    return FutureBuilder<Product>(
      future: productProvider.fetchProduct(widget.productId),
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.productId != null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Product existingProduct;

        if (widget.productId != null) {
          existingProduct = snapshot.data;

          selectedUnit = existingProduct.units != null &&
                  selectedUnitIndex < existingProduct.units.length
              ? existingProduct.units[selectedUnitIndex]
              : null;

          //  loadValues(productBloc, existingProduct, authBloc.userId);
        } else {
          //Add Logic
          // loadValues(productBloc, null, authBloc.userId);
        }

        return Scaffold(
            body: pageBody(
                false, productProvider, context, existingProduct, cartProvider));
      },
    );
  }

  Future<void> addToCart(CartProvider provider, Product product,
      int quantity, ProductUnit productUnit) async {
    try {
      provider.addToCart(product, quantity, productUnit);
      bool result = true;  //await provider.addToCart(product, quantity, productUnit);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Zum Warenkorb hinzugefügt.'),/*SEHR GUTE WAHL!\n*/
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      print("THE ERROR ${e.toString()}");
    }
  }

  Widget pageBody(bool isIOS, ProductProvider productBloc, BuildContext context,
      Product existingProduct, CartProvider cartProvider) {
    return ListView(
      children: <Widget>[
        productDetailsCard(context, existingProduct, cartProvider),
      ],
    );
  }

  List<Widget> createProductUnits(List<ProductUnit> units) {
    List<Widget> widgets = [];

    for (int i = 0; i < units.length; i++) {
      widgets.add(
        RadioListTile(
          value: i,
          groupValue: selectedUnitIndex,
          title: Text('${units[i].price.toStringAsFixed(2)} €'),
          subtitle: Text(units[i].text),
          onChanged: (j) {
             setState(() {
              selectedUnitIndex = j;
              selectedUnit = units[j];
            });
          },
          selected: selectedUnitIndex == i,
          activeColor: Colors.red,
        ),
      );
    }
    return widgets;
  }

  Widget productDetailsCard(
      BuildContext context, Product product, CartProvider cartProvider) {
    double imageSwipeHeight = MediaQuery.of(context).size.height / 2 - 80;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Container(
          height: imageSwipeHeight + 30,
          width: width,
          child: ImageSwipe(imageList: product.imageUrl),
        ),
        Positioned(
          top: imageSwipeHeight,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          // Arrow back
          padding: EdgeInsets.only(top: 10.0, left: 10.0),
          child: FloatingActionButton(
            heroTag: 1,
            mini: true,
            elevation: 0.0,
            backgroundColor: Colors.grey[400],
            child: Icon(Icons.arrow_back, color: Colors.white, size: 15.0),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 10.0, left: MediaQuery.of(context).size.width - 60.0),
          child: FloatingActionButton(
            heroTag: 2,
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(AppRoutes.shopping_bag);
            },
            backgroundColor: AppColors.lightblue,
            mini: true,
            elevation: 0.0,
            child: Icon(Icons.shopping_cart, color: Colors.white, size: 15.0),
          ),
        ),
        Positioned(
          top: 10.0,
          left: MediaQuery.of(context).size.width - 30.0,
          child: Container(
            height: 18.0,
            width: 18.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.0), color: Colors.white),
            child: Center(
              child: Text(
                cartProvider.cartLength.toString(),
                style: TextStyle(
                    color: Color(0xFF399D63), fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
                top: imageSwipeHeight + 10, left: 20.0, right: 15.0),
            child: Column(
              children: <Widget>[
                Text(
                  product.productName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                ExpandableText.lines(
                  product.description,
                  lines: 4,
                  textStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                  ),
                  arrowWidgetBuilder: (expanded) => Base.buildArrow(expanded),
                ),
                SizedBox(height: 10.0),
                Column(
                  children: createProductUnits(product.units),
                ),
                (product.availableUnits > 1)
                    ? Text(
                        'vorrätig',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      )
                    : Text('nach Anfrage',
                        style: TextStyles.bodyRed, textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 36,
                            ),
                            onPressed: () {
                              if (quantity != 1) {
                                setState(() {
                                  quantity -= 1;
                                });
                              }
                            }),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.lightblue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
                          child: Text(
                            "$quantity",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 25.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 36,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                quantity += 1;
                                if (product.availableUnits > 1 &&
                                    quantity > product.availableUnits)
                                  quantity = product.availableUnits;
                              });
                            }),
                      ),
                    ]),
                AppButton(
                    buttonText: 'IN DEN WARENKORB',
                    onPressed: () {
                      addToCart(cartProvider, product, quantity, selectedUnit);
                    }),
              ],
            ))
      ],
    );
  }
}
