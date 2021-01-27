import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';

import 'package:fisch_aus_steinbachtal/models/cart_item.dart';
import 'package:fisch_aus_steinbachtal/models/order.dart';
import 'package:fisch_aus_steinbachtal/provider/cart_provider.dart';
import 'package:fisch_aus_steinbachtal/screens/order_flow_pages.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/services/order_services.dart';
import 'package:fisch_aus_steinbachtal/widgets/send_email.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingBag extends StatefulWidget {
  @override
  _ShoppingBagState createState() => _ShoppingBagState();

    static makeOrder(provider, context) async {
    if (provider==null)
       provider = Provider.of<CartProvider>(context);
    final OrderModel order =
        await Navigator.of(context).push(OrderFlow.route());

    if (order != null && order.agb) {
      await OrderServices().saveOrder(order);

      // Bestätigungs-Email

      /*File file = order.makePdf().then((file){*/
      String html = order.toHtml();
      sendmail(order.userEmail, html, null /*file*/);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Die Bestätigungs-Email wurde verschickt!'),
        ),
      );

      //  });

      provider.emptyCart();

      if (provider.cart.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Der Warenkorb wurde geleert.'),
          ),
        );
      }
    }
  }
}

class _ShoppingBagState extends State<ShoppingBag> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CartProvider>(context);
    var userService = Provider.of<AuthenticationService>(context);

    return ChangeNotifierProvider<CartProvider>.value(
        value: provider,
        child: Consumer<CartProvider>(builder: (context, provider, child) {
          if (provider.cart == null) {
            // provider.cart();
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: provider.cartLength,
                      itemBuilder: (context, index) {
                        CartItemModel cartItem = provider.cart[index];

                        return InkWell(
                            onTap: () => Navigator.of(context).pushNamed(
                                '/product_details/${cartItem.productId}'),
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Container(
                                height: 160,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(3, 2),
                                          blurRadius: 30)
                                    ]),
                                child: Row(
                                  children: <Widget>[
                                    (cartItem.image != null &&
                                            cartItem.image != "")
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                            child: Image.network(
                                              cartItem.image,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/fish1.png',
                                            height: 120.0,
                                            width: 120,
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: [
                                              RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: cartItem.name +
                                                          "\n\n",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text:
                                                          "${cartItem.productUnit.price.toStringAsFixed(2)} \€\n",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                  TextSpan(
                                                      text:
                                                          "${cartItem.productUnit.text}\n\n",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                  TextSpan(
                                                      text: "Anzahl: ",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .lightblue,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  /*TextSpan(
                                                      text: cartItem.quantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.deepOrange,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),*/
                                                ]),
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    // '-'
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1.0,
                                                              left: 0),
                                                      child: IconButton(
                                                          icon: Icon(
                                                              Icons.remove,
                                                              size: 20),
                                                          onPressed: () {
                                                            provider
                                                                .removeFromList(
                                                                    cartItem);
                                                          }),
                                                    ),
                                                    // Anzahl
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .lightblue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 8, 8, 8),
                                                        child: Text(
                                                          "${cartItem.quantity}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    // '+'
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1.0),
                                                      child: IconButton(
                                                          icon: Icon(Icons.add,
                                                              size: 18,
                                                              color:
                                                                  Colors.red),
                                                          onPressed: () {
                                                            provider.addToList(
                                                                cartItem);
                                                          }),
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                provider
                                                    .deleteFromList(cartItem);
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      }),
                ),
                Container(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "RECHNUNGSBETRAG:\n",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            TextSpan(
                                text:
                                    "     ${provider.getTotalCartPrice().toStringAsFixed(2)} \€",
                                style: TextStyle(
                                    color: AppColors.red,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                          ]),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.deepOrange),
                            child: TextButton(
                              child: Text(
                                "Bestellung prüfen",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                if (checkOrder(provider, userService)) {
                                 /* if (userService.isGuest) {
                                    userService.orderInProgress = true;
                                    changeScreen(context, LoginPage());
                                    return;
                                  }*/

                                  await ShoppingBag.makeOrder(provider, context);

                                  /*final OrderModel order =
                                      await Navigator.of(context)
                                          .push(OrderFlow.route());

                                  if (order != null && order.agb) {
                                    await OrderServices().saveOrder(order);

                                    // Bestätigungs-Email

                                    /*File file = order.makePdf().then((file){*/
                                    String html = order.toHtml();
                                    sendmail(
                                        order.userEmail, html, null /*file*/);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Die Bestätigungs-Email wurde verschickt!'),
                                      ),
                                    );

                                    //  });

                                    provider.emptyCart();

                                    if (provider.cart.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Der Warenkorb wurde geleert.'),
                                        ),
                                      );
                                    }
                                  }*/

                                  /*  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PDFViewerScaffold(
                                          appBar: AppBar(
                                            leading: BackButton(onPressed: () {
                                              Navigator.of(context) .pushNamed(AppRoutes.homepage);
                                                }),
                                            backgroundColor: Colors.black,
                                            title: Text('VIELEN DANK\nfür Ihre Bestellung'),
                                          ),
                                          path: file.path)
                                  ));*/

                                }
                              },
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Base.bottomNavbarHeight + 20),
              ],
            ),
          );
        }));
  }

  bool checkOrder(CartProvider provider, AuthenticationService userService) {
    if (provider.totalCartPrice == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Ihr Warenkorb ist leer',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
      return false;
    }

    return true;
  }


}
