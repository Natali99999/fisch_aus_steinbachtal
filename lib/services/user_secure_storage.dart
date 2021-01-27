import 'dart:convert';
import 'package:fisch_aus_steinbachtal/models/cart_item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
     await _storage.write(key: key, value: value);
  }

  Future<String> readSecureData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
    //Fluttertoast.showToast(msg: "deleteSecureData:\n$key");
  }

  empty() async {
    deleteSecureData('email');
   // deleteSecureData('password');
    deleteSecureData('name');
    deleteSecureData('phone');
  // deleteSecureData('id');
    deleteSecureData('cart');
  }

  get name {
    return readSecureData('name');
  }

  void setName(String value) {
    writeSecureData('name', value);
  }

 get email {
    return readSecureData('email');
  }

  void setEmail(String value) {
    writeSecureData('email', value);
  }

  get phone {
    return readSecureData('phone');
  }

  void setPhone(String value) {
    writeSecureData('phone', value);
  }

  /*get password {
    return readSecureData('password');
  }

  set password(String value) {
    writeSecureData('password', value);
  }

  get id {
    return readSecureData('id');
  }

  set id(String value) {
    writeSecureData('id', value);
  }*/

  updateCart(List<CartItemModel> cartItemList) {
    List<String> listString = [];
    for (CartItemModel cartItem in cartItemList) {
      Map<String, dynamic> jsonMap = CartItemModel.toJsonMap(cartItem);
      listString.add(json.encode(jsonMap));
    }

    String t = listString.toString();
    writeSecureData('cart', t);
  }

  List<CartItemModel> cart() {
    List<CartItemModel> cartItemList = [];
    /* List<String> listString = _pref.getStringList('cart');
    if (listString != null && listString.length > 0) {
      for (String string in listString) {
        Map jsonMap = json.decode(string);
        CartItemModel cartItem = CartItemModel.fromJson(jsonMap);
        cartItemList.add(cartItem);
      }
      return cartItemList;
    }*/

    readSecureData("cart").then((data) {
      if (data != null && data.isNotEmpty) {
        final List<dynamic> jsonResult = json.decode(data);
        jsonResult.forEach((value) {
          print(value);
          CartItemModel cartItem = CartItemModel.fromJson(value);
          cartItemList.add(cartItem);
        });
      }
    });
   
    return cartItemList;
  }

  emptyCart() {
    deleteSecureData('cart');
  }
}
