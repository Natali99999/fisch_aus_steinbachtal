import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisch_aus_steinbachtal/models/cart_item.dart';
import 'package:fisch_aus_steinbachtal/models/contact.dart';
import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/models/user_model.dart';

class ProductCategories {
  List<String> _categories = [];
  List<String> get categories => _categories;
  ProductCategories(this._categories);

  ProductCategories.fromFirestore(Map<String, dynamic> firestore) {
    _categories =
        firestore['fisch'].map<String>((cat) => cat.toString()).toList();
  }
}

class UnitTypes {
  List<String> _types = [];
  UnitTypes(this._types);

  List<String> get types => _types;
  UnitTypes.fromFirestore(Map<String, dynamic> firestore) {
    _types =
        firestore['production'].map<String>((type) => type.toString()).toList();
  }
}

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(UserModel /*ApplicationUser*/ user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<UserModel> fetchUser(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) => UserModel.fromFirestore(snapshot.data()));
  }

  Stream<UnitTypes> fetchUnitTypes() {
    return _db
        .collection('types')
        .doc('units')
        .snapshots()
        .map((snapshot) => UnitTypes.fromFirestore(snapshot.data()));
  }

  Stream<ProductCategories> fetchProductCategories() {
    return _db
        .collection('types')
        .doc('categories')
        .snapshots()
        .map((snapshot) => ProductCategories.fromFirestore(snapshot.data()));
  }

  Future<DocumentSnapshot> fetchAgbPdfUrl() {
    return _db.collection('pdfs').doc('agb').get().then((doc) {
     // var data = doc.data();
      return doc;
    });
  }

  Future<void> setProduct(Product product) {
    var options = SetOptions(merge: true);
    return _db
        .collection('products')
        .doc(product.productId)
        .set(product.toMap(), options);
  }

  Future<bool> removeProductImage(String productId, List<String> list) async {
    return await _db
        .collection('products')
        .doc(productId)
        .update({"imageUrl": FieldValue.arrayUnion(list)}).then((_) {
      print("success!");
      return Future.value(true);
    }).catchError((error) {
      print('Error: deleted image $error');
      Future.value(false);
    });
  }

  Future<void> removeProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }

  Future<Product> fetchProduct(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .get()
        .then((snapshot) => Product.fromFirestore(snapshot.data()));
  }

  Stream<List<Product>> fetchProductsByVendorId(String vendorId) {
    return _db
        .collection('products')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) =>
            snapshot.map((doc) => Product.fromFirestore(doc.data())).toList());
  }

  Stream<List<Product>> fetchAvailableProducts() {
    return _db
        .collection('products')
        .where('availableUnits', isGreaterThan: 0)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) =>
            snapshot.map((doc) => Product.fromFirestore(doc.data())).toList());
  }

  void addToCart(String userId, CartItemModel cartItem) {
    //print("THE USER ID IS: $userId");
    //print("cart items are: ${cartItem.toString()}");
    _db.collection('users').doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  void removeFromCart(String userId, CartItemModel cartItem) {
    // print("THE USER ID IS: $userId");
    //print("cart items are: ${cartItem.toString()}");
    _db.collection('users').doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }

  Future<void> emptyCart(String userId) async {
    _db
        .collection('users')
        .doc(userId)
        .update({"cart": []});
  }

  Future<void> toCart(String userId, CartItemModel cartItem) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .add(cartItem.toMap());
  }

  Future<UserModel> getUserById(String userId) {
    return _db.collection('users').doc(userId).get().then((doc) {
      return UserModel.fromSnapshot(doc);
    });
  }

  Future<List<Device>> getUserDeviceInfo(String userId) async {
    final deviceRef = _db.collection("users").doc(userId).collection("devices");
    QuerySnapshot eventsQuery = await deviceRef.get();

    return eventsQuery.docs
        .map((deviceInfo) => Device.fromSnapshot(deviceInfo))
        .toList();
  }

  Future<ContactData> getContactData() {
    return _db.collection('kontakt').doc('fisch_aus_steinbachtal').get().then((doc) {
      return ContactData.fromSnapshot(doc);
    });
  }
}
