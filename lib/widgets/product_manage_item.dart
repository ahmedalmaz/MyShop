import 'package:flutter/material.dart';
import 'package:myshop/Providers/products.dart';
import 'package:myshop/screens/product-edit-screen.dart';
import 'package:provider/provider.dart';

class ProductsManageItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;

  ProductsManageItem({this.title, this.imageUrl, this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold=ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ProductEditScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try{
                  await Provider.of<Products>(context, listen: false).deleteProduct(id);
                }catch(error){
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(SnackBar(content: Text('Deleting failed'),),);
                }


              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
