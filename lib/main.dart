import 'package:flutter/material.dart';
import 'package:myshop/Providers/auth.dart';
import 'package:myshop/Providers/cart.dart';
import 'package:myshop/Providers/order.dart';
import 'package:myshop/Providers/products.dart';
import 'package:myshop/screens/auth_screen.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/order_screen.dart';
import 'package:myshop/screens/product-edit-screen.dart';
import 'package:myshop/screens/product_details_screen.dart';
import 'package:myshop/screens/products_screen.dart';
import 'package:myshop/screens/splash_screen.dart';
import './screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
            update: (ctx, auth, previousOrders) => Order(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders))
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: ' My Shop',
          theme: ThemeData(
              primarySwatch: Colors.teal,
              accentColor: Colors.tealAccent,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryLogIn(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductOverviewScreen.routName: (ctx) => ProductOverviewScreen(),
            ProductDetailsScreen.routName: (ctx) => ProductDetailsScreen(),
            CartScreen.routName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            ProductsScreen.routeName: (ctx) => ProductsScreen(),
            ProductEditScreen.routeName: (ctx) => ProductEditScreen()
          },
        ),
      ),
    );
  }
}
