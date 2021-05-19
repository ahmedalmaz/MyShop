import 'package:flutter/material.dart';
import 'package:myshop/Providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFav;
  ProductsGrid(this.isFav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productList = isFav ? productsData.getFavItems : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          mainAxisSpacing: 10),
      itemCount: productList.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: productList[index],
          child: ProductItem(
              // id: productList[index].id,
              // title: productList[index].title,
              // imageUrl: productList[index].imageUrl,
              ),
        );
      },
    );
  }
}
