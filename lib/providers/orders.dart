import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping_app/providers/Cart.dart';

import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double total;
  final List<CartItem> orderItems;
  final DateTime date;

  OrderItem(
    this.id,
    this.total,
    this.orderItems,
    this.date,
  );
}

class Orders with ChangeNotifier {
  List<OrderItem> orderList = [];
  final String authToken;
  final String userId;

  Orders(
      {required this.authToken, required this.userId, required this.orderList});

  List<OrderItem> get order {
    return [...orderList];
  }

  Future<void> fetchOrders() async {
    String url =
        'https://shoppinapp-27646-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> ordersDecode = json.decode(response.body);
    List<OrderItem> loadedOrders = [];
    if (ordersDecode == null) return;
    ordersDecode.forEach((id, orderData) {
      loadedOrders.add(OrderItem(
          id,
          orderData['total'],
          (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    item['id'],
                    item['title'],
                    item['price'],
                    item['quantity'],
                  ))
              .toList(),
          DateTime.parse(orderData['date'])));
    });
    orderList = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProd, double total) async {
    final orderTime = DateTime.now();
    String url =
        'https://shoppinapp-27646-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken';

    if (total == 0) return;
    final resonse = await http.post(Uri.parse(url),
        body: json.encode({
          'total': total,
          'date': orderTime.toIso8601String(),
          'products': cartProd
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }));
    orderList.insert(
        0,
        OrderItem(
          json.decode(resonse.body)['name'],
          total,
          cartProd,
          orderTime,
        ));
    notifyListeners();
  }
}
