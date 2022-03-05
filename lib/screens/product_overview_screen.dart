import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/Cart.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/badge.dart';
import 'package:shopping_app/widgets/productGrid.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static String routeName = ' /product-overview-screen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isInite = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInite) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInite = false;
    super.didChangeDependencies();
  }

  var showFavorites = false;
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption value) {
                setState(() {
                  if (value == FilterOption.Favorite) {
                    showFavorites = true;
                  } else {
                    showFavorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text("Favorite Items"),
                        value: FilterOption.Favorite),
                    PopupMenuItem(
                        child: Text('All items'), value: FilterOption.All)
                  ]),
          Consumer<Cart>(
            builder: (_, cartData, child) => Badge(
              key: UniqueKey(),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
              ),
              value: cartData.itemCount.toString(),
              color: Colors.red,
            ),
          )
        ],
        title: Text('My shop'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavorites),
      drawer: AppDrawer(),
    );
    return scaffold;
  }
}
