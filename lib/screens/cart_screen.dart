import 'package:flutter/material.dart';
import 'package:myshop/Providers/cart.dart' show Cart;
import 'package:myshop/Providers/order.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$ ${cart.totalQuantity.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) => CartItem(
                title: cart.items.values.toList()[index].title,
                id: cart.items.values.toList()[index].id,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                productId: cart.items.keys.toList()[index],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  OrderButton(this.cart);
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
   bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child:isLoading? CircularProgressIndicator() :Text(
          'Order Now',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: (widget.cart.totalQuantity <= 0 || isLoading)
            ? null
            : () async{
          setState(() {
            isLoading=true;
          });
               await Provider.of<Order>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(),
                    widget.cart.totalQuantity);
                widget.cart.clear();
                setState(() {
                  isLoading=false;
                });
              },
      );
  }
}
