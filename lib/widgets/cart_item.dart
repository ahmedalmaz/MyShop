import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({this.price, this.productId, this.title, this.id, this.quantity});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are You Sure'),
                  content: Text('Do you want to remove item from the cart ?'),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(ctx).pop(false);
                    }, child: Text('No'),),
                    TextButton(onPressed: (){
                      Navigator.of(ctx).pop(true);

                    }, child: Text('Yes'))
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      direction: DismissDirection.startToEnd,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$$price')),
            ),
            title: Text(title),
            subtitle: Text('Total: ${price * quantity} \$'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
