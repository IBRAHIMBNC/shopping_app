import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping_app/models/http-exception.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> productItems = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String authToken = '';
  String userId = '';

  Products({required this.productItems, String? authToken, String? userId});

  List<Product> get items {
    return [...productItems];
  }

  List<Product> get favoriteItems {
    return productItems.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return productItems.firstWhere((pro) => pro.id == id);
  }

  Future<void> addProduct(Product p) async {
    String url =
        'https://shoppinapp-27646-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
            'createrId': userId
          }));
      Product newPro = new Product(
          title: p.title,
          imageUrl: p.imageUrl,
          description: p.description,
          price: p.price,
          id: json.decode(response.body)['name']);
      productItems.add(newPro);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product p) async {
    final String url =
        'https://shoppinapp-27646-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken';
    int ind = productItems.indexWhere((element) {
      return element.id == id;
    });
    if (ind >= 0) {
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
          }));
      productItems[ind] = p;
    } else
      print("...");
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final String url =
        'https://shoppinapp-27646-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authToken';
    final deletedProdIndex = productItems.indexWhere((prod) => prod.id == id);
    Product? backuProd = productItems[deletedProdIndex];
    productItems.removeWhere((element) {
      return element.id == id;
    });
    notifyListeners();
    var response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      productItems.insert(deletedProdIndex, backuProd);
      notifyListeners();
      throw HttpException(messege: 'Item could not be deleted');
    }
    backuProd = null;
  }

  Future<void> fetchData([bool filterByUserId = false]) async {
    var filterOn =
        filterByUserId ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    String url =
        'https://shoppinapp-27646-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authToken$filterOn';
    final response = await http.get(Uri.parse(url));
    final intoMap = json.decode(response.body) as Map<String, dynamic>;
    url =
        'https://shoppinapp-27646-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourite/$userId.json?auth=$authToken';
    final favResponse = await http.get(Uri.parse(url));
    final favData = json.decode(favResponse.body);

    final List<Product> fetchedProdList = [];
    if (intoMap == null) return;
    intoMap.forEach((prodId, data) {
      fetchedProdList.add(Product(
        id: prodId,
        title: data['title'],
        description: data['description'],
        imageUrl: data['imageUrl'],
        isFavourite: favData == null ? false : favData[prodId] ?? false,
        price: data['price'],
      ));
      productItems = fetchedProdList;
    });

    notifyListeners();
  }
}
