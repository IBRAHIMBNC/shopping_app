import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final String url =
        'https://shoppinapp-27646-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourite/$userId/$id.json?auth=$token';
    isFavourite = !isFavourite;

    notifyListeners();
    await http.put(Uri.parse(url), body: json.encode(isFavourite));
  }
}
