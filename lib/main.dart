import 'package:flutter/material.dart';
import 'package:myshop/Providers/cart.dart';
import 'package:myshop/Providers/order.dart';
import 'package:myshop/Providers/products.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/order_screen.dart';
import 'package:myshop/screens/product-edit-screen.dart';
import 'package:myshop/screens/product_details_screen.dart';
import 'package:myshop/screens/products_screen.dart';
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
          create:(ctx)=> Products(),
        ),
        ChangeNotifierProvider(
          create:(ctx)=> Cart(),
        ),
        ChangeNotifierProvider(
          create:(ctx)=> Order(),
        )
      ],
      child: MaterialApp(
        title: ' My Shop',
        theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.tealAccent,
            fontFamily: 'Lato'),

        routes: {
          ProductOverviewScreen.routName:(ctx)=>ProductOverviewScreen(),
          ProductDetailsScreen.routName: (ctx) => ProductDetailsScreen(),
          CartScreen.routName:(ctx)=>CartScreen(),
          OrderScreen.routeName:(ctx)=>OrderScreen(),
          ProductsScreen.routeName:(ctx)=>ProductsScreen(),
          ProductEditScreen.routeName:(ctx)=>ProductEditScreen()
        },
      ),
    );
  }
}
