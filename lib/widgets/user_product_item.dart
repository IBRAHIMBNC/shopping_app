import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;

  const UserProductItem(
      {required this.title, required this.imageUrl, required this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () => Navigator.pushNamed(
                  context, EditProductScreen.routeName,
                  arguments: id),
            ),
            IconButton(
                color: Colors.red,
                icon: Icon(Icons.delete),
                onPressed: () => showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        content: Text("Are you sure to delete this item?"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                try {
                                  Navigator.of(ctx).pop();
                                  await Provider.of<Products>(context,
                                          listen: false)
                                      .deleteProduct(id);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(content: Text('item deleted ')));
                                } catch (_) {
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('deleting item failed ')));
                                }
                              },
                              child: Text("Yes")),
                          TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text("No"))
                        ],
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
