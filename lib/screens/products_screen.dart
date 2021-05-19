import 'package:flutter/material.dart';
import 'package:myshop/screens/product-edit-screen.dart';
import '../Providers/products.dart';
import '../widgets/main_drawer.dart';
import '../widgets/product_manage_item.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = '/productsScreen';

  Future<void> _refreshProducts ( BuildContext context)async{
   await Provider.of<Products>(context, listen: false).fetchAndGetProducts();

  }
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(ProductEditScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProducts(context),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: products.items.length,
                itemBuilder: (ctx, index) => Column(
                      children: [
                        ProductsManageItem(
                          title: products.items[index].title,
                          imageUrl: products.items[index].imageUrl,
                          id: products.items[index].id,
                        ),
                        Divider(),
                      ],
                    ))),
      ),
    );
  }
}
