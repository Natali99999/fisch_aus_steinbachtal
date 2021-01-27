import 'package:fisch_aus_steinbachtal/models/order.dart';
import 'package:fisch_aus_steinbachtal/provider/cart_provider.dart';
import 'package:fisch_aus_steinbachtal/screens/order_config_page2.dart';
import 'package:fisch_aus_steinbachtal/screens/order_final_page.dart';
import 'package:fisch_aus_steinbachtal/screens/order_person_data.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderFlow extends StatelessWidget {
  static Route<OrderModel> route() {
    return MaterialPageRoute(builder: (_) {
      return OrderFlow();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CartProvider>(context);
    var userService = Provider.of<AuthenticationService>(context);

   /* String email, name, phone;
    if (userService.isGuest) {
      final SecureStorage _storage = SecureStorage();
      _storage.email.then((value) {
        email = value;
      });
      _storage.name.then((value) {
        name = value;
      });

      _storage.phone.then((value) {
        phone = value;
      });
    }
    else{
       name=userService.name;
       email=userService.email;
       phone=userService.phone;
    }*/

    return FlowBuilder(
      state: OrderModel.create(
         /* userName: name,
          userEmail: email,
          userMobile: phone,*/
          userId: userService.isGuest ? '': userService.userId,
          agb: false,
          totalPrice: provider.totalCartPrice,
          cart: provider.cart,
          terminDate: '',
          terminTime: '10-12'),
      onGeneratePages: onGeneratePages,
    );
  }
}

List<Page> onGeneratePages(OrderModel order, List<Page> pages) {
 
  return [
    //if (UserHelper.isGuest) LoginPage();

                               

    if (order.userEmail == null) 
      MaterialPage(child: OrderPersonDataPage()),
    if (order.userEmail != null) MaterialPage(child: OrderConfigPage2()),
    if (order.orderNr != null && !order.agb)
      MaterialPage(child: OrderFinalPage()),
  ];
}
