import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/screen_navigation.dart';
import 'package:fisch_aus_steinbachtal/screens/my_orders.dart';
import 'package:fisch_aus_steinbachtal/screens/pdf_screen.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/widgets/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes.dart';

class NavigateDrawer extends StatefulWidget {
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  static String adminTitle = 'Admin';
  static String productsTitle = 'Startseite';
  static String orderTitle ='Bestellungen';

  static String dividerTitle = '  Rechtliche Hinweise';
  static String impressumTitle = "Impressum";
  //static String impressumPageTitle = "Impressum";
  //static String impressumStorageFilename =
  //    "pdfs/impressum_fisch_aus_steinbachtal.pdf";
  //static String impressumDistFilename = 'impressum.pdf';

  static String agbTitle = "Nutzungsbedingungen";
  //static String agbPageTitle = "Nutzungsbedingungen";
  //static String agbStorageFilename = "pdfs/agb_fisch_aus_steinbachtal.pdf";
  //static String agbDistFilename = 'agb.pdf';

  static String datenschutzTitle = "Datenschutz";
  //static String datenschutzPageTitle = "Datenschutz";
  //static String datenschutzStorageFilename =
  //    "pdfs/datenschutz_fisch_aus_steinbachtal.pdf";
  //static String datenschutzDistFilename = 'datenschutz.pdf';

  
  static String contactTitle = "Kontakt";
  static String exitTitle = "Abmelden";

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthenticationService>(context);

    String headerName = auth.isGuest
        ? 'Gast'
        : auth.isAdmin
            ? 'Admin'
            : auth.isVendor
                ? 'Verkäufer: ${auth.appUser.name}'
                : auth.appUser.name;

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        // Header
        UserAccountsDrawerHeader(
          accountName: Text('$headerName'),
          accountEmail: Text('${auth.email}'),
          decoration: BoxDecoration(
            color: AppColors.lightblue,
          ),
          currentAccountPicture:
              CircleAvatar(backgroundImage: AssetImage(Base.logo)),
        ),

        //  Admin
        if (auth.isAdmin)
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.settings, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text(adminTitle,
                style: TextStyle(color: Colors.black, fontSize: 18.0)),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.admin_homepage);
            },
          ),
        // Produkte
        ListTile(
          leading: new IconButton(
            icon: new Icon(Icons.home, color: Colors.black),
            onPressed: () => null,
          ),
          title: Text(productsTitle,
              style: TextStyle(color: Colors.black, fontSize: 18.0)),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.homepage);
          },
        ),

        // Bestellungen/'Meine Bestellungen
        if (!auth.isGuest)
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.shop_two_rounded, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text(orderTitle,
                style: TextStyle(color: Colors.black, fontSize: 18.0)),
            onTap: () {
              auth.isVendor
                  ? changeScreen(context, OrdersScreen())
                  : changeScreen(context, MyOrdersScreen(uid: auth.userId));
            },
          ),

        // Rechtliche Hinweise
        Divider(thickness: 2),
        Text(dividerTitle,
            style: TextStyle(color: Colors.black, fontSize: 18.0)),
        // Impressum
        ListTile(
          leading: Icon(Icons.assignment, color: Colors.black),
          title: Text(impressumTitle,
              style: TextStyle(color: Colors.black, fontSize: 18.0)),
          onTap: () {
            changeScreen(
                context, MarkdownPage(storageFilename: Base.impressumStorageFilename)
               /* PdfPage(
                    pageTitle: impressumPageTitle,
                    storageFilename: impressumStorageFilename,
                    distFilename: impressumDistFilename)*/);
          },
        ),
        // Datenschutz
        ListTile(
          leading: Icon(Icons.assignment_late, color: Colors.black),
          title: Text(datenschutzTitle,
              style: TextStyle(color: Colors.black, fontSize: 18.0)),
          onTap: () {
            changeScreen(
                context, 
                MarkdownPage(storageFilename: Base.datenschutzStorageFilename));
          },
        ),
        // AGB
        ListTile(
          leading: Icon(Icons.assignment_late, color: Colors.black),
          title: Text(agbTitle,
              style: TextStyle(color: Colors.black, fontSize: 18.0)),
          onTap: () {
            changeScreen(
                context, MarkdownPage(storageFilename: Base.agbStorageFilename));
                /*PdfPage(
                    pageTitle: agbPageTitle,
                    storageFilename: agbStorageFilename,
                    distFilename: agbDistFilename));*/
          },
        ),
        // Kontakt
        ListTile(
          leading: Icon(Icons.outlined_flag, color: Colors.black),
          title: Text(contactTitle,
              style: TextStyle(color: Colors.black, fontSize: 18.0)),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.contact_page);
          },
        ),
        // Abmelden
       /* if (UserHelper.isGuest)
          ListTile(
              leading: Icon(Icons.login, color: Colors.red),
              title: Text('Anmelden',
                  style: TextStyle(color: Colors.red, fontSize: 18.0)),
              onTap: () {
                changeScreen(context, LoginPage());
              }),*/

        ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.red),
          title: Text(exitTitle,
              style: TextStyle(color: Colors.red, fontSize: 18.0)),
          onTap: () {
            context.read<AuthenticationService>().signOut();
          },
        ),

        
      ],
    ));
  }
}
