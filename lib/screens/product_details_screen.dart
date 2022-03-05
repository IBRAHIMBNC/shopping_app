import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final Product prod = Provider.of<Products>(context).findById(id);
    return Scaffold(
        appBar: AppBar(
          title: Text(prod.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                child: Hero(
                  tag: prod.id,
                  child: Image.network(
                    prod.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "\$${prod.price}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Text(
                  prod.description,
                  softWrap: true,
                ),
              )
            ],
          ),
        ));
  }
}
