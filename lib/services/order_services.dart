import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisch_aus_steinbachtal/models/cart_item.dart';
import 'package:fisch_aus_steinbachtal/models/order.dart';
import 'package:fisch_aus_steinbachtal/models/user_model.dart';

class OrderServices {
  String collection = "orders";

  FirebaseFirestore _db = FirebaseFirestore.instance;

  void createOrder({
    String userId,
    String id,
    String description,
    String status,
    List<CartItemModel> cart,
    double totalPrice,
    String terminDate,
    String terminTime,
  }) {
    List<Map> convertedCart = [];
    List<String> vendorIds = [];

    for (CartItemModel item in cart) {
      convertedCart.add(item.toMap());

      if (vendorIds.contains(item.vendorId) == false) {
        vendorIds.add(item.vendorId);
      }
    }

    _db.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "vendorIds": vendorIds,
      "cart": convertedCart,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status,
      "terminDate": terminDate,
      "terminTime": terminTime
    });
  }

  Future<void> saveOrder(OrderModel order) async {
    Map<String, dynamic> orderMap = order.toMap();
    await _db.collection("orders").doc(order.id).set(orderMap);
  }

  Future<List<OrderModel>> getUserOrders({String userId}) async {
    CollectionReference ref = _db.collection(collection);
    QuerySnapshot eventsQuery =
        await ref.where('userId', isEqualTo: userId).get();

    return eventsQuery.docs
        .map((order) => OrderModel.fromSnapshot(order))
        .toList();
  }

  Future<void> updateOrderStatus({String orderId, String status}) async {
    final deviceRef = _db.collection(collection).doc(orderId);

    return await deviceRef.update({"status": status});
  }

  Future<List<OrderModel>> getAllUserOrders({String vendorId}) async {
    CollectionReference ref = _db.collection(collection);
    QuerySnapshot eventsQuery =
        await ref.where('vendorIds', arrayContains: vendorId).get();

    return eventsQuery.docs
        .map((order) => OrderModel.fromSnapshot(order))
        .toList();
  }

  Future<List<UserModel>> getUserList() async {
    CollectionReference ref = _db.collection('users');
    QuerySnapshot eventsQuery = await ref.get();

    return eventsQuery.docs
        .map((user) => UserModel.fromSnapshot(user))
        .toList();
  }

  Future<List<Device>> getUserDeviceInfo(String userId) async {
    final deviceRef = _db.collection("users").doc(userId).collection("devices");

    QuerySnapshot eventsQuery = await deviceRef.get();

    return eventsQuery.docs
        .map((deviceInfo) => Device.fromSnapshot(deviceInfo))
        .toList();
  }
}
