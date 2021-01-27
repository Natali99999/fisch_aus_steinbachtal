import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/text.dart';
import 'package:fisch_aus_steinbachtal/models/contact.dart';
//import 'package:fisch_aus_steinbachtal/models/contact.dart';
import 'package:fisch_aus_steinbachtal/provider/cart_provider.dart';
import 'package:fisch_aus_steinbachtal/screens/fish_plates.dart';
import 'package:fisch_aus_steinbachtal/screens/location_page.dart';
import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
//import 'package:fisch_aus_steinbachtal/services/contact_service.dart';
//import 'package:fisch_aus_steinbachtal/services/authentification_service.dart';
import 'package:fisch_aus_steinbachtal/widgets/navigateDrawer.dart';
import 'package:fisch_aus_steinbachtal/widgets/shopping_bag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fisch_aus_steinbachtal/widgets/product_customer.dart';

class HomePage extends StatefulWidget {
  final int currentIndex;
  HomePage(this.currentIndex);
  @override
  _HomePageState createState() => _HomePageState();
}

enum enum_pages { products, fish_plates, celebrate, shopping_cart }

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  static List<String> _pagesTitle = [
    "Produkte",
    "Fischplatten",
    "Feiern",
    "Warenkorb",
  ];

  static List<IconData> _pagesIcon = [
    Icons.category,
    Icons.bubble_chart,
    Icons.emoji_people_outlined,
    Icons.shopping_cart,
  ];

  final List<Widget> _pages = [
    ProductsCustomer(),
    FishPlatesPage(),
    LocationPage(),
    ShoppingBag()
  ];

  var _currentIndex = 0;
  
  @override
  void initState() {
    _currentIndex = widget.currentIndex;
     super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _getCustomAppBar(BuildContext context, int productCount) {
    ContactData contactData = Provider.of<ContactData>(context);
  
    String logoText = contactData != null ? contactData.logoText : 'unknown logo';
    //String logo = contactData != null ? contactData.logo : '';

    return PreferredSize(
        preferredSize: Size.fromHeight(Base.appbarHeight),
        child: Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.white, Colors.teal[50]])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // openDrawer
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
                // Logotext
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                      _currentIndex == 0
                          ? logoText
                          : _currentIndex == 3
                              ? '${_pagesTitle[_currentIndex]} ($productCount)'
                              : _pagesTitle[_currentIndex],
                      style: TextStyles.logoStyle2),
                ),
                IconButton(
                    tooltip: 'Schliessen',
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                                     // title: Text("App schliessen"),
                                      content: Text("Wollen Sie die App wirklich schliessen?"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("Nein"),
                                          onPressed: () => Navigator.pop(context, false),
                                        ),
                                        TextButton(
                                            child: Text("Ja"),
                                            onPressed: () {
                                              context.read<AuthenticationService>().signOut();
                                              SystemNavigator.pop();
                                            }),
                                      ],
                                    )
                    );
                    }),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
   
    return Scaffold(
      key: _scaffoldKey,
      appBar: _getCustomAppBar(context, cartProvider.cartLength),
      // backgroundColor: Colors.transparent,
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: _getNavBar(context, cartProvider.cartLength),
        );
      }),
      drawer: NavigateDrawer(),
    );
  }

  _getNavBar(BuildContext context, productCount) {
    Color color = AppColors.lightblue;
    return Stack(
      children: [
        // Pages
        _pages[_currentIndex],

        // Bottom navigation bar
        // Welle zeichnen
        Positioned(
          bottom: 0,
          child: ClipPath(
            clipper: NavBarClipper(),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, Colors.teal.shade500]),
              ),
            ),
          ),
        ),
        // Icons setzen
        Positioned(
            bottom: 45,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                    _pagesIcon[0], _currentIndex == 0, onTabTapped, 0),
                SizedBox(width: 1),
                _buildNavItem(
                    _pagesIcon[1], _currentIndex == 1, onTabTapped, 1),
                SizedBox(width: 1),
                _buildNavItem(
                    _pagesIcon[2], _currentIndex == 2, onTabTapped, 2),
                SizedBox(width: 1),
                _buildNavItemShoppingCart(_pagesIcon[3], _currentIndex == 3,
                    onTabTapped, 3, productCount),
              ],
            )),
        // Titel setzen
        Positioned(
            bottom: 10,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_pagesTitle[0], style: (_currentIndex == 0) ? TextStyles.navButtonsSelectedTitleStyle :TextStyles.navButtonsTitleStyle),
                SizedBox(width: 1),
                Text(_pagesTitle[1], style: (_currentIndex == 1) ? TextStyles.navButtonsSelectedTitleStyle :TextStyles.navButtonsTitleStyle),
                SizedBox(width: 1),
                Text(_pagesTitle[2], style: (_currentIndex == 2) ? TextStyles.navButtonsSelectedTitleStyle :TextStyles.navButtonsTitleStyle),
                SizedBox(width: 1),
                Text(_pagesTitle[3], style: (_currentIndex == 3) ? TextStyles.navButtonsSelectedTitleStyle :TextStyles.navButtonsTitleStyle),
              ],
            )),
      ],
    );
  }

  _buildNavItem(IconData icon, bool active, Function onTabTapped, int index) {
  
    return GestureDetector(
      onTap: () {
        onTabTapped(index);
      },
      child: active
          ? CircleAvatar(radius: 35,
             backgroundImage: AssetImage(Base.logo))
          : CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                child: Icon(icon, color: Colors.white.withOpacity(0.9)),
              ),
            ),
    );
  }
}

_buildNavItemShoppingCart(IconData icon, bool active, Function onTabTapped,
    int index, int productCount) {

  
  return GestureDetector(
    onTap: () {
      onTabTapped(index);
    },
    child: active
        ? CircleAvatar(radius: 35, backgroundImage:AssetImage(Base.logo))
        : Container(
            width: 70.0,
            height: 60,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    child: Icon(icon, color: Colors.white.withOpacity(0.9)),
                  ),
                ),
                // Text: shopping_cart product count
                Positioned(
                  top: 37.0,
                  left: 29,
                  child: Container(
                    height: 18.0,
                    width: 18.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.0),
                        color: AppColors.straw),
                    child: Center(
                      child: Text(
                        productCount.toString(),
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
  );
}

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.cubicTo(sw / 12, 0, sw / 12, 2 * sh / 5, 2 * sw / 12, 2 * sh / 5);
    path.cubicTo(3 * sw / 12, 2 * sh / 5, 3 * sw / 12, 0, 3 /*4*/ * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 7 /*8*/ * sw / 12, 0);
    path.cubicTo(
        9 * sw / 12, 0, 9 * sw / 12, 2 * sh / 5, 10 * sw / 12, 2 * sh / 5);
    path.cubicTo(11 * sw / 12, 2 * sh / 5, 11 * sw / 12, 0, sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
