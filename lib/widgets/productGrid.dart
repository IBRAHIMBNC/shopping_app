import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool fav;
  ProductGrid(this.fav);
  @override
  Widget build(BuildContext context) {
    final Products productData = Provider.of<Products>(context);
    final List<Product> products =
        fav ? productData.favoriteItems : productData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index], child: ProductItem()),
      itemCount: products.length,
    );
  }
}
