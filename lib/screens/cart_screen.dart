import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/Cart.dart' show Cart;
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cartInst = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Chip(label: Text('\$${cartInst.total.toStringAsFixed(2)}')),
                  OrderButton(cartInst: cartInst, order: order)
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(4),
              child: ListView.builder(
                itemBuilder: (_, index) {
                  return CartItem(
                    prodId: cartInst.items.keys.toList()[index],
                    title: cartInst.items.values.toList()[index].title,
                    id: cartInst.items.values.toList()[index].id,
                    price: cartInst.items.values.toList()[index].price,
                    quantity: cartInst.items.values.toList()[index].quantity,
                  );
                },
                itemCount: cartInst.itemCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    required this.cartInst,
    required this.order,
  });

  final Cart cartInst;
  final Orders order;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.cartInst.total <= 0
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await widget.order
                    .addOrder(widget.cartInst.items.values.toList(),
                        widget.cartInst.total)
                    .then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                });
                widget.cartInst.clearCart();
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'ORDER NOW',
                style: TextStyle(fontSize: 16),
              ));
  }
}
