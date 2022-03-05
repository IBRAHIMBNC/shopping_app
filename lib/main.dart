import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/Cart.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/screens/order_screen.dart';
import 'package:shopping_app/screens/product_details_screen.dart';
import 'package:shopping_app/screens/product_overview_screen.dart';
import 'package:shopping_app/screens/splash_screen.dart';
import 'package:shopping_app/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (ctx) => Products(productItems: []),
              update: (_, auth, previousProducts) => Products(
                  authToken: auth.token,
                  userId: auth.userId,
                  productItems: previousProducts!.items.isEmpty
                      ? []
                      : previousProducts.items)),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(orderList: [], authToken: '', userId: ''),
            update: (_, auth, previousOrders) => Orders(
                authToken: auth.token!,
                userId: auth.userId!,
                orderList: previousOrders!.orderList.isEmpty
                    ? []
                    : previousOrders.orderList),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            home: authData.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: (ctx, autoLoginResult) =>
                        autoLoginResult.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductOverviewScreen.routeName: (_) => ProductOverviewScreen(),
              ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrderScreen.routeName: (_) => OrderScreen(),
              UserProductScreen.routeName: (_) => UserProductScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen(),
              AuthScreen.routeName: (_) => AuthScreen(),
            },
          ),
        ));
  }
}
