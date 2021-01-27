//import 'dart:io';
//import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/models/cart_item.dart';
import 'package:fisch_aus_steinbachtal/widgets/date_time_widget.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:pdf/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderModel {
  static const ID = "id";
  static const ORDER_NR = "orderNr";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";
  static const VENDOR_IDS = "vendorIds";
  static const TERMIN_DATE = "terminDate";
  static const TERMIN_TIME = "terminTime";
  static const USER_MOBILE = "user_mobile";
  static const COMMENT = "comment";
  static const USER_NAME = "user_name";
  static const USER_EMAIL = "user_email";
  static const USER_STREET = "user_street";
  static const USER_HOME_NR = "user_home_nr";
  static const USER_TOWN = "user_town";
  static const USER_POSTCODE = "user_post_code";

  String orderNr;
  String userId;
  String status;

  double totalPrice;
  String terminDate = '';
  String terminTime = '10-12';

  List<CartItemModel> cart;
  String comment;
  String userMobile;
  String userName;
  String userEmail;
  String userAddressStreet;
  String userAddressHomeNr;
  String userTown;
  String userPostCode;

  int createdAt;
  List<String> vendorIds;
  String id;
  bool agb = false;

  OrderModel();

  OrderModel copyWith(
      {String userId,
      String userName,
      String userEmail,
      String userMobile,
      String id,
      String orderNr,
      String status,
      List<CartItemModel> cart,
      double totalPrice,
      String terminDate,
      String terminTime,
      String comment,
      int createdAt,
      List<String> vendorIds,
      String userAddressHomeNr,
      String userAddressStreet,
      String userTown,
      String userPostCode,
      bool agb}) {
    return OrderModel.create(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userEmail: userEmail ?? this.userEmail,
        userMobile: userMobile ?? this.userMobile,
        cart: cart ?? this.cart,
        totalPrice: totalPrice ?? this.totalPrice,
        terminDate: terminDate ?? this.terminDate,
        terminTime: terminTime ?? this.terminTime,
        agb: agb ?? this.agb,
        orderNr: orderNr ?? this.orderNr);
  }

  OrderModel.create(
      {this.userId,
      this.userName,
      this.userEmail,
      this.userMobile,
      this.cart,
      this.totalPrice,
      this.terminDate,
      this.terminTime,
      this.agb,
      this.orderNr})
      : comment = '',
        userAddressHomeNr = '',
        userAddressStreet = '',
        userTown = '',
        userPostCode = '' {
    createdAt = DateTime.now().millisecondsSinceEpoch;

   
    var uuid = Uuid();
    id = uuid.v4();

    if (terminDate == null || terminDate.isEmpty) {
      String day = 'Sa';
      String date = DateTimeWidget.makeDate(day, createdAt);
      terminDate = '$day, den $date';
    }

    //var rng = new Random();
   // orderNr = "${rng.nextInt(100).toString()}";
    status = "offen";

    vendorIds = [];

    if (cart != null) {
      for (CartItemModel item in cart) {
        //if (vendorIds.contains(item.vendorId) == false) {
        vendorIds.add(item.vendorId);
        //}
      }
    }
  }

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data()[ID];
    orderNr = snapshot.data()[ORDER_NR];
    totalPrice = snapshot.data()[TOTAL];
    status = snapshot.data()[STATUS];
    userId = snapshot.data()[USER_ID];
    createdAt = snapshot.data()[CREATED_AT];
    vendorIds = _convertVendorList(snapshot.data()[VENDOR_IDS]) ?? [];
    cart = _convertCartItems(snapshot.data()[CART]) ?? [];
    terminDate = snapshot.data()[TERMIN_DATE];
    terminTime = snapshot.data()[TERMIN_TIME];
    comment = snapshot.data()[COMMENT];
    userMobile = snapshot.data()[USER_MOBILE];
    userName = snapshot.data()[USER_NAME];
    userEmail = snapshot.data()[USER_EMAIL];
    userAddressStreet = snapshot.data()[USER_STREET];
    userAddressHomeNr = snapshot.data()[USER_HOME_NR];
    userTown = snapshot.data()[USER_TOWN];
    userPostCode = snapshot.data()[USER_POSTCODE];
  }

  Map<String, dynamic> toMap() {
    List<Map> _convertedCart = [];
    List<String> _vendorIds = [];

    for (CartItemModel item in cart) {
      _convertedCart.add(item.toMap());

      if (_vendorIds.contains(item.vendorId) == false) {
        _vendorIds.add(item.vendorId);
      }
    }

    return {
      ID: id,
      ORDER_NR: orderNr,
      TOTAL: totalPrice,
      STATUS: status,
      USER_ID: userId,
      CREATED_AT: createdAt,
      VENDOR_IDS: _vendorIds,
      CART: _convertedCart,
      TERMIN_DATE: terminDate,
      TERMIN_TIME: terminTime,
      COMMENT: comment,
      USER_MOBILE: userMobile,
      USER_NAME: userName,
      USER_EMAIL: userEmail,
      USER_STREET: userAddressStreet,
      USER_HOME_NR: userAddressHomeNr,
      USER_TOWN: userTown,
      USER_POSTCODE: userPostCode
    };
  }

  OrderModel.fromFirestore(Map<String, dynamic> firestore) {
    id = firestore[ID];
    orderNr = firestore[ORDER_NR];
    totalPrice = firestore[TOTAL];
    status = firestore[STATUS];
    userId = firestore[USER_ID];
    createdAt = firestore[CREATED_AT];
    vendorIds = firestore[VENDOR_IDS];
    cart = _convertCartItems(firestore[CART]) ?? [];
    terminDate = firestore[TERMIN_DATE];
    terminTime = firestore[TERMIN_TIME];
    comment = firestore[COMMENT];
    userMobile = firestore[USER_MOBILE];
    userName = firestore[USER_NAME];
    userEmail = firestore[USER_EMAIL];
    userAddressStreet = firestore[USER_STREET];
    userAddressHomeNr = firestore[USER_HOME_NR];
    userTown = firestore[USER_TOWN];
    userPostCode = firestore[USER_POSTCODE];
  }

  List<CartItemModel> _convertCartItems(List cart) {
    List<CartItemModel> convertedCart = [];
    for (Map cartItem in cart) {
      convertedCart.add(CartItemModel.fromFirestore(cartItem));
    }
    return convertedCart;
  }

  List<String> _convertVendorList(List vendors) {
    List<String> convertedVendors = [];
    for (String vendorItem in vendors) {
      convertedVendors.add(vendorItem);
    }
    return convertedVendors;
  }

  String get date {
    final df = DateFormat('dd.MM.yyyy  HH:mm:ss');
    String date = df.format(DateTime.fromMillisecondsSinceEpoch(createdAt));
    return date;
  }

  String toHtml() {
    /* <td align="center" bgcolor="#70bbd9" style="padding: 40px 0 30px 0;">
    <img src="${Base.logo}"/ alt="Creating Email Magic" width="300" height="230" style="display: block;" />
    </td>*/

    String html = '''<h1 style="color: #2e6c80;">${Base.appTitle}</h1>
    
    <p>Hallo $userName, </p>
    <p>VIELEN DANK FÜR IHRE BESTELLUNG</p>
    <p>  </p>
    <p>Ihre Bestellung werden wir schnellstmöglich bearbeiten.</p>
    <p>  </p>

   
    <head>
      <style>
      table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
      }
      </style>
    </head>
    <tbody>

    
    <h2 style="color: #2e6c80;">Persönliche Daten</h2>
     <table>
           <tr>
            <td>Name       </td>
            <td>$userName</td>
          </tr>
          <tr>
            <td>E-Mail     </td>
            <td>$userEmail</td>
          </tr>
          <tr>
            <td>Vorwahl/Tel.</td>
            <td>$userMobile</td>
          </tr>
     
       </table>
    </tbody>
    <h2 style="color: #2e6c80;">Ihre Bestellung im Überblick</h2>
    <table>
      <tbody>
           <tr>
              <td>Bestellnummer:</td>
              <td>$orderNr</td>
            </tr>
            <tr>
              <td>Bestelldatum:  </td>
              <td>$date</td>
            </tr>
            <tr>
              <td>Abholltermin:  </td>
              <td>$terminDate $terminTime Uhr</td>
            </tr>
             <tr>
              <td>Kommentar:      </td>
              <td>$comment</td>
            </tr>
    </tbody>
    </table>

    <p>  </p>

    <table>
      <thead>
          <tr>
            <td>Artikel          </td>
            <td>Menge       </td>
            <td>Preis       </td>
            <td>Gesamtpreis </td>
          </tr>
      </thead>''';




    html += '<tbody>';
    for (CartItemModel cartItem in cart) {
      double sum = cartItem.quantity * cartItem.productUnit.price;

      String text = '''<tr>
          <td>${cartItem.name} (${cartItem.productUnit.text})</td>
          <td>${cartItem.quantity}</td>
          <td>${cartItem.productUnit.price.toStringAsFixed(2)}</td>
          <td>${sum.toStringAsFixed(2)}</td>
         </tr>
     ''';

      html += text;
    }

    html += '</tbody></table>';

    html += '''
   <p><strong>Warenwert ${totalPrice.toStringAsFixed(2)}</strong><br /><strong>Barbezahlung bei Abholung</strong></p>
   
   
    
    <p>Viele Grüße und bis bald,</p>
    <p>Ihr Team von ${Base.appTitle}</p>
 ''';

    /* <td align="right">
    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
      <td style="font-size: 0; line-height: 0;" width="20">&nbsp;</td>
      <td>
        <a href="https://www.facebook.com/fischraucherei.ribkin.5">
        <img src="images/fb.gif" alt="Facebook" width="38" height="38" style="display: block;" border="0" />
        </a>
      </td>
      </tr>
    </table>
    </td>*/

    return html;
  }

  writeOnPdf() {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a5,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        var text = <pw.Widget>[
          pw.Header(level: 0, child: pw.Text(Base.appTitle)),
          pw.Paragraph(text: "Hallo $userName,"),
          pw.Paragraph(
              text:
                  "Vielen Dank für Ihre Bestellung bei ${Base.appTitle}\nIhre Bestellung werden wir schnellstmöglich bearbeiten."),
          pw.Header(level: 1, child: pw.Text("Persönliche Daten")),
          pw.Paragraph(text: "Name: $userName"),
          pw.Paragraph(text: "E-Mail: $userEmail"),
          pw.Paragraph(text: "Vorwahl/Tel.: $userMobile"),
          pw.Header(level: 1, child: pw.Text("Ihre Bestellung im Überblick")),
          pw.Paragraph(text: "Bestellnummer: $orderNr"),
          pw.Paragraph(text: "Bestelldatum: $date"),
          pw.Paragraph(text: "Abholltermin: $terminDate $terminTime Uhr"),
          pw.Paragraph(text: "Kommentar: $comment")
        ];

        for (int i = 0; i < cart.length; i++) {
          text.add(pw.Paragraph(text: "\n"));
          text.add(pw.Paragraph(
              text: "Produkt: ${cart[i].name} (${cart[i].productUnit.text})"));
          text.add(pw.Paragraph(text: "Anzahl: ${cart[i].quantity}"));
          text.add(pw.Paragraph(
              text: "Preis: ${cart[i].productUnit.price.toStringAsFixed(2)}"));
          /* double sum = cart[i].quantity * cart[i].productUnit.price;
          String sumText = sum.toStringAsFixed(2);
          text.add(pw.Paragraph(text: "Gesamtpreis: $sumText"));*/
        }

        var text1 = <pw.Widget>[
          pw.Paragraph(text: "\n"),
          pw.Paragraph(text: "Warenwert ${totalPrice.toStringAsFixed(2)}"),
          pw.Paragraph(text: "Barbezahlung bei Abholung"),
          pw.Paragraph(text: "\n"),
          pw.Paragraph(text: "Viele Grüße und bis bald,"),
          pw.Paragraph(text: "Ihr Team von ${Base.appTitle}")
        ];

        return text + text1;
      },
    ));
    return pdf;
  }

  /*(Document pdf, String fileName) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    fileName = "$documentPath/example.pdf";
    File file = File(fileName);

    file.writeAsBytesSync(await pdf.save());
    return Future.value(file);
  }*/

  /*Future<File> makePdf() async {
    Document pdf = writeOnPdf();
    return await savePdf(pdf, 'bestellung.pdf');
  
  }*/
}
