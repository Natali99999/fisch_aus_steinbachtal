import 'package:flutter/foundation.dart';

class ProductUnit {
  String name;
  double price;
  String text;

  ProductUnit({this.price, this.name, this.text});
  set setName(String _name) {
    name = _name;
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'text': text};
  }

  ProductUnit.fromFirestore(Map<String, dynamic> firestore)
      : name = firestore['name'],
        text = firestore['text'],
        price = double.parse(firestore['price'].toString());

   factory ProductUnit.fromJson(Map<String, dynamic> jsonData) {
    return ProductUnit(
        name: jsonData['name'],
        text: jsonData['text'],
        price:  double.parse(jsonData['price'].toString())
    );
  }

  static Map<String, dynamic> toJsonMap(ProductUnit item) => {
        'name': item.name,
        'text': item.text,
        'price': item.price
      }; 
}
     


class Product {
  final String productName;
  final String description;
  final String productCategory;
  final int availableUnits;
  final String vendorId;
  final String productId;
  final List<String> imageUrl;
  final bool approved;
  final String note;

  //  public variable
  List<ProductUnit> units = [];

  Product(
      {@required this.approved,
      @required this.availableUnits,
      @required this.productCategory,
      this.imageUrl,
      this.note = "",
      @required this.productId,
      @required this.productName,
      this.description = "",
      this.units,
      @required this.vendorId});

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'description': description,
      'productCategory': productCategory,
      'availableUnits': availableUnits,
      'approved': approved,
      'imageUrl': imageUrl,
      'note': note,
      'productId': productId,
      'vendorId': vendorId,
      'units': units.map((unit) => unit.toMap()).toList(),
    };
  }

  Product.fromFirestore(Map<String, dynamic> firestore)
      : productName = firestore['productName'],
        units = _convertUnits(firestore['units']),
        description = firestore['description'],
        productCategory = firestore['productCategory'],
        availableUnits = firestore['availableUnits'],
        approved = firestore['approved'],
        imageUrl = _convertImages(firestore['imageUrl']),
        note = firestore['note'],
        productId = firestore['productId'],
        vendorId = firestore['vendorId'];
}

List<String> _convertImages(List images) {
  List<String> _convertedImages = <String>[];
  for (int item = 0; item < images.length; item++) {
    _convertedImages.add(images[item].toString());
  }
  return _convertedImages;
}

List<ProductUnit> _convertUnits(List _units) {
  List<ProductUnit> _convertedUnits = <ProductUnit>[];
  for (int item = 0; item < _units.length; item++) {
    _convertedUnits.add(ProductUnit.fromFirestore(_units[item]));
  }
  return _convertedUnits;
}
