import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/Cart.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product prod = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context);
    final Auth auth = Provider.of<Auth>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: prod.id),
          child: Hero(
              tag: prod.id,
              child: Image.network(prod.imageUrl, fit: BoxFit.cover)),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            prod.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, prod, _) => IconButton(
              icon: prod.isFavourite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () async {
                await prod.toggleFavorite(auth.token!, auth.userId!);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Item added to cart'),
                action: SnackBarAction(
                  onPressed: () => cart.undoItem(prod.id),
                  label: "UNDO",
                ),
              ));
              cart.addItem(prod.id, prod.price, prod.title);
            },
          ),
        ),
      ),
    );
  }
}
