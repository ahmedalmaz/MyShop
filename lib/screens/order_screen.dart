import 'package:flutter/material.dart';
import 'package:myshop/Providers/order.dart'show Order;
import 'package:myshop/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName='/OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isLoading=false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async{
      setState(() {
        isLoading=true;
      });
     await Provider.of<Order>(context,listen: false).fetchAndSetData();
     setState(() {
       isLoading=false;
     });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final order=Provider.of<Order>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body:isLoading? Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(itemCount:order.orders.length,
      itemBuilder: (ctx, index)=>OrderItem(order.orders[index]),
      ),
    );
  }
}
