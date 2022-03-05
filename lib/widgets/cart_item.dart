import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/Cart.dart' show Cart;

class CartItem extends StatelessWidget {
  final String id;
  final String prodId;
  final String title;
  final double price;
  final int quantity;

  const CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity,
      required this.prodId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Are you sure?"),
              content: Text("Are you sure to delete this item?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text('Yes')),
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text('No'))
              ],
            );
          }),
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(prodId),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        color: Colors.red,
        padding: EdgeInsets.only(right: 30),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: FittedBox(child: Text('\$$price')),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
