import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myshop/Providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get orders {
    return [..._items];
  }

  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://my-shop-c1620-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);

    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData==null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((element) => CartItem(
                title: element['title'],
                id: element['id'],
                price: element['price'],
                quantity: element['quantity']))
            .toList(),
      ));
    });
    _items = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.parse(
        'https://my-shop-c1620-default-rtdb.firebaseio.com/orders.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'products': cartProducts
                .map((element) => {
                      'id': element.id,
                      'quantity': element.quantity,
                      'price': element.price,
                      'title': element.title,
                    })
                .toList(),
            'dateTime': timeStamp.toIso8601String()
          }));
      _items.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
