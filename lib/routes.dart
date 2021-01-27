import 'package:fisch_aus_steinbachtal/screens/admin_homepage.dart';
import 'package:fisch_aus_steinbachtal/screens/contact_page.dart';
import 'package:fisch_aus_steinbachtal/screens/forgot_screen.dart';
import 'package:fisch_aus_steinbachtal/screens/location_page.dart';
import 'package:fisch_aus_steinbachtal/screens/edit_product.dart';
import 'package:fisch_aus_steinbachtal/screens/home_page.dart';
import 'package:fisch_aus_steinbachtal/screens/login_page.dart';
import 'package:fisch_aus_steinbachtal/screens/my_orders.dart';
import 'package:fisch_aus_steinbachtal/screens/product_details.dart';
import 'package:fisch_aus_steinbachtal/screens/register_page.dart';
import 'package:fisch_aus_steinbachtal/screens/verify_auth_screen.dart';
import 'package:fisch_aus_steinbachtal/widgets/authentication_wrapper.dart';
import 'package:fisch_aus_steinbachtal/widgets/shopping_bag.dart';
import 'package:flutter/material.dart';
import 'models/product.dart';

abstract class AppRoutes {
  static const String authLogin = '/login';
  static const String authRegister = '/register';
  static const String homepage = '/homepage';
  static const String forgotPswScreen = '/forgotPsw';
  static const String verifyAuthScreen = '/verifyAuth';
  static const String admin_homepage = '/admin_homepage';
  static const String user_orders = '/user_orders';
  static const String edit_product = '/editproduct';
  static const String shopping_bag = '/shopping_bag';
  static const String contact_page = '/contact_page';
  static const String auth_wrapper = '/auth_wrapper';
  static const String location_page = '/location_page';

  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
          case "/verifyAuth":
        return MaterialPageRoute(builder: (context) => VerifyAuthScreen());
      case "/forgotPsw":
        return MaterialPageRoute(builder: (context) => ForgotPassword());
      case "/contact_page":
        return MaterialPageRoute(builder: (context) => ContactPage());
      case "/location_page":
        return MaterialPageRoute(builder: (context) => LocationPage());

       case "/auth_wrapper":
        return MaterialPageRoute(builder: (context) => AuthenticationWrapper());
      case "/homepage":
        return MaterialPageRoute(
            builder: (context) => HomePage(0));
      case "/user_orders":
        return MaterialPageRoute(
            builder: (context) =>
                MyOrdersScreen(uid: ModalRoute.of(context).settings.arguments));

      case "/register":
        return MaterialPageRoute(builder: (context) => RegisterPage());
      case "/shopping_bag":
        return MaterialPageRoute(builder: (context) => ShoppingBag());

      case "/login":
        return MaterialPageRoute(builder: (context) => LoginPage());

      case "/admin_homepage":
        return MaterialPageRoute(builder: (context) => AdminHomePage());
         case "/editproduct":
        return MaterialPageRoute(builder: (context) {
          Product product =
              ModalRoute.of(context).settings.arguments as Product;
          return EditProduct(product: product);
        });
        default:
        var routeArray = settings.name.split('/');
      
        if (settings.name.contains('/product_details/')) {
          return MaterialPageRoute(
              builder: (context) => ProductDetails(
                    productId: routeArray[2],
                  ));
        }

        return MaterialPageRoute(builder: (context) => LoginPage());
    }
  }
}
