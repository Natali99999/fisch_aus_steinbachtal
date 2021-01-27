import 'package:fisch_aus_steinbachtal/models/user_model.dart';
import 'package:fisch_aus_steinbachtal/services/order_services.dart';
import 'package:flutter/widgets.dart';

class MyOrderPageProvider extends ChangeNotifier {
  List<dynamic> orders;

  Future<void> getOrders(String userId) async {
    this.orders = await OrderServices().getUserOrders(userId: userId);
    this.notifyListeners(); // for callback to view
  }
}

class AllUsersOrdersPageProvider extends ChangeNotifier {
  List<dynamic> orders;
  List<UserModel> users;

  Future<void> getOrders(String vendorId) async {
    this.orders = await OrderServices().getAllUserOrders(vendorId: vendorId);
    this.notifyListeners(); // for callback to view
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await OrderServices().updateOrderStatus(orderId: orderId, status: status);
    this.notifyListeners(); // for callback to view
  }

  Future<void> getUsers() async {
    this.users = await OrderServices().getUserList();

    this.notifyListeners();
  }
}
