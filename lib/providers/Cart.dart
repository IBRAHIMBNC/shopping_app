import 'package:flutter/Material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
    this.id,
    this.title,
    this.price,
    this.quantity,
  );
}

class Cart with ChangeNotifier {
  Map<String, CartItem> cartItems = {};
  Map<String, CartItem> get items {
    return {...cartItems};
  }

  int get itemCount {
    return cartItems.length;
  }

  double get total {
    double total = 0.0;
    cartItems.forEach((id, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String prodId) {
    cartItems.remove(prodId);
    notifyListeners();
  }

  void undoItem(String productId) {
    if (!cartItems.containsKey(productId)) return;
    if (cartItems[productId]!.quantity > 1) {
      cartItems.update(
          productId,
          (existingItem) => CartItem(
                existingItem.id,
                existingItem.title,
                existingItem.price,
                existingItem.quantity - 1,
              ));
    } else {
      cartItems.remove(productId);
    }
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (cartItems.containsKey(productId)) {
      cartItems.update(
          productId,
          (value) => CartItem(
                value.id,
                value.title,
                value.price,
                value.quantity + 1,
              ));
    } else {
      cartItems.putIfAbsent(
          productId,
          () => CartItem(
                DateTime.now().toString(),
                title,
                price,
                1,
              ));
    }
    notifyListeners();
  }

  void clearCart() {
    cartItems = {};
    notifyListeners();
  }
}
