import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisch_aus_steinbachtal/provider/cart_provider.dart';
import 'package:fisch_aus_steinbachtal/provider/customer_bloc.dart';
import 'package:fisch_aus_steinbachtal/provider/product_provider.dart';
import 'package:fisch_aus_steinbachtal/routes.dart';
import 'package:fisch_aus_steinbachtal/screens/landing_page.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/services/contact_service.dart';
import 'package:fisch_aus_steinbachtal/services/firestore_services.dart';
//import 'package:fisch_aus_steinbachtal/services/maps_services.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:fisch_aus_steinbachtal/services/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helper/colors.dart';
import 'helper/base.dart';
import 'models/contact.dart';


final firestoreService = FirestoreService();
final customerBloc = CustomerBloc();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 // await UserPreferences().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<ContactData>(
          create: (context)  =>  ContactDataServices().getContactData(),
        ),
        ChangeNotifierProvider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
       // ChangeNotifierProvider.value(value: MapService()),
        Provider(
          create: (context) => customerBloc,
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),

     
        
      ],
      child: MaterialApp(
      /* localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('de')
        ],*/
        debugShowCheckedModeBanner: false,
        title: Base.appTitle,
        theme: ThemeData(
          // Define the default brightness and colors.
          // brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: AppColors.lightblue,

          // Define the default font family.
          fontFamily: 'Georgia',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
         /* textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),*/
        ),
        /* theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),*/
        onGenerateRoute: AppRoutes.materialRoutes,
        home: LandingPage(),
      ),
    );
  }
}
