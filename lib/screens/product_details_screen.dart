import 'package:flutter/material.dart';
import 'package:myshop/Providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routName = '/product_details_screen';
  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context).settings.arguments as String;
    final loadProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadProduct.title),
      ),
      body: SingleChildScrollView(
          child: Column(

        children: [
          Container(
            height: 400,
            width: double.infinity,
            child: Image.network(
              loadProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\$ ${loadProduct.price}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 30
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            ' ${loadProduct.description}',
            style: TextStyle(
                color: Colors.grey,

                fontSize: 25
            ),
          )
        ],
      )),
    );
  }
}
