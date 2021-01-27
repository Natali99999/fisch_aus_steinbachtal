import 'package:fisch_aus_steinbachtal/models/product.dart';

class CartItemModel {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";
  static const PRODUCT_ID = "productId";
  static const QUANTITY = "quantity";
  static const VENDOR_ID = "vendorId";
  static const UNIT_TYPE = "unit";

  String id;
  String name;
  String image;
  String productId;
  String vendorId;
  int quantity;
  ProductUnit productUnit;

  CartItemModel(
      {this.id,
      this.image,
      this.name,
      this.productId,
      this.vendorId,
      this.quantity,
      this.productUnit});

  CartItemModel.fromFirestore(Map<String, dynamic> firestore) {
    id = firestore[ID];
    name = firestore[NAME];
    image = firestore[IMAGE];
    productId = firestore[PRODUCT_ID];
    vendorId = firestore[VENDOR_ID];
    quantity = firestore[QUANTITY];
    productUnit = ProductUnit.fromFirestore(firestore[UNIT_TYPE]);
  }

  Map<String, dynamic> toMap() => {
        ID: id,
        IMAGE: image,
        NAME: name,
        PRODUCT_ID: productId,
        QUANTITY: quantity,
        UNIT_TYPE: productUnit.toMap(),
        VENDOR_ID: vendorId,
      };

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }   

  factory CartItemModel.fromJson(Map<String, dynamic> jsonData) {
    return CartItemModel(
        id: jsonData[ID],
        name: jsonData[NAME],
        image:  jsonData[IMAGE],
        productId: jsonData[PRODUCT_ID],
        vendorId: jsonData[VENDOR_ID],
        quantity:  jsonData[QUANTITY],
        productUnit:  ProductUnit.fromJson(jsonData[UNIT_TYPE])
    );
  }

  static Map<String, dynamic> toJsonMap(CartItemModel item) => {
        ID: item.id,
        IMAGE: item.image,
        NAME: item.name,
        PRODUCT_ID: item.productId,
        QUANTITY: item.quantity,
        UNIT_TYPE: ProductUnit.toJsonMap(item.productUnit),
        VENDOR_ID: item.vendorId,
      }; 
}
