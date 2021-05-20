import 'package:flutter/material.dart';
import 'package:myshop/Providers/auth.dart';
import 'package:myshop/Providers/cart.dart';
import 'package:myshop/Providers/products.dart';
import '../Providers/product.dart';
import '../screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem({this.id, this.imageUrl, this.title});
  @override
  Widget build(BuildContext context) {
    final selectedProduct = Provider.of<Product>(context, listen: false);
    final authData=Provider.of<Auth>(context , listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // var isf=selectedProduct.isFavorite;
    // void saveFav(String id , bool fav) async {
    //   var _editProduct = Product(
    //       imageUrl: selectedProduct.imageUrl,
    //       description: selectedProduct.description,
    //       price: selectedProduct.price,
    //       title: selectedProduct.title,
    //       id: selectedProduct.id,
    //       isFavorite: fav);
    //   try {
    //     final response =await Provider.of<Products>(context, listen: false)
    //         .updateProduct(id, _editProduct);
    //
    //     if(response.s)
    //   } catch (error) {}
    // }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routName,
                arguments: selectedProduct.id);
          },
          child: Image.network(
            selectedProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavorite(authData.token,authData.userId);
                // saveFav(selectedProduct.id,product.isFavorite);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.black54,
          title: Text(
            selectedProduct.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                  id: selectedProduct.id,
                  title: selectedProduct.title,
                  price: selectedProduct.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item Added to the Cart'),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(selectedProduct.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
