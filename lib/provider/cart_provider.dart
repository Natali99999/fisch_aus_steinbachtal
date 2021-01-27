import 'package:fisch_aus_steinbachtal/models/cart_item.dart';
import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/services/user_secure_storage.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> _cart/*= []*/;
  double totalCartPrice = 0.0;

  List<CartItemModel> get cart {
    if (_cart == null) {
      _cart = SecureStorage().cart();
      if (_cart == null) {
        _cart = [];
      }
    }
    return _cart;
  }

  int get cartLength => cart != null ? _cart.length : 0;

  void addToCart(Product product, int quantity, ProductUnit productUnit) {
    String cartItemId = product.productId;

    var cartItem = CartItemModel(
        id: cartItemId,
        image: product.imageUrl[0],
        name: product.productName,
        productId: product.productId,
        vendorId: product.vendorId,
        quantity: quantity,
        productUnit: productUnit);

    _cart.add(cartItem);
    SecureStorage().updateCart(_cart);
    notifyListeners();
  }

  void addToList(CartItemModel cartItem) {
    bool isPresent = false;

    if (cartLength > 0) {
      for (int i = 0; i < cartLength; i++) {
        if (_cart[i].id == cartItem.id) {
          increaseItemQuantity(cartItem);
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        _cart.add(cartItem);
      }
    } else {
      _cart.add(cartItem);
    }

    SecureStorage().updateCart(_cart);
    notifyListeners();
  }

  void removeFromList(CartItemModel cartItem) {
    if (cartItem.quantity > 1) {
      decreaseItemQuantity(cartItem);
    } else {
      _cart.remove(cartItem);
    }

    SecureStorage().updateCart(_cart);
    notifyListeners();
  }

  void deleteFromList(CartItemModel cartItem) {
    _cart.remove(cartItem);
    SecureStorage().updateCart(_cart);
    notifyListeners();
  }

  void increaseItemQuantity(CartItemModel cartItem) {
    cartItem.incrementQuantity();
    SecureStorage().updateCart(_cart);
    notifyListeners();
  }

  void decreaseItemQuantity(CartItemModel cartItem) {
    cartItem.decrementQuantity();
    SecureStorage().updateCart(_cart);
    notifyListeners();
  }

  double getTotalCartPrice() {
    double _priceSum = 0;
    if (_cart != null) {
      for (int i = 0; i < cartLength; i++) {
        _priceSum += _cart[i].productUnit.price * _cart[i].quantity;
      }
    }
    totalCartPrice = _priceSum;
    return totalCartPrice;
  }

  void emptyCart() {
    SecureStorage().emptyCart();
    _cart.clear();
    notifyListeners();
  }
}
