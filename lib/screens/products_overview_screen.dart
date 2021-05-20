import 'package:flutter/material.dart';
import 'package:myshop/Providers/cart.dart';
import 'package:myshop/Providers/product.dart';
import 'package:myshop/Providers/products.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:myshop/widgets/main_drawer.dart';
import 'package:myshop/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorite, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routName = '/product_overview_screen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool isFav = false;
  bool isInit = true;
  bool isLoading = false;

  Future<void> _refreshProducts(BuildContext context) async {
    if(isInit){
    setState(() {
      isLoading=true;
    });}
    await Provider.of<Products>(context, listen: false)
        .fetchAndGetProducts();
    if(isInit){
    setState(() {
      isLoading=false;
      isInit=false;
    });}
  }

  // @override
  // void didChangeDependencies() {
  //   if (isInit) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     Provider.of<Products>(context,listen: false)
  //         .fetchAndGetProducts()
  //         .then((_) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //   }
  //
  //   isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    _refreshProducts(context);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (options) {
              setState(() {
                if (options == FilterOptions.Favorite) {
                  isFav = true;
                } else {
                  isFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorite'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartDate, ch) => Badge(
              child: ch,
              value: cartDate.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routName);
              },
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(isFav),
    );
  }
}
