import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.title,
      @required this.id,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (!_items.containsKey(prodId)) {
      return;
    }
    if (_items[prodId].quantity > 1) {
      _items.update(
        prodId,
        (prod) => CartItem(
            title: prod.title,
            id: prod.id,
            price: prod.price,
            quantity: prod.quantity - 1),
      );
    }else{
      _items.remove(prodId);
    }
  }

  double get totalQuantity {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem({String id, String title, double price}) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingCArtItem) => CartItem(
            title: existingCArtItem.title,
            id: existingCArtItem.id,
            price: existingCArtItem.price,
            quantity: existingCArtItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
            title: title,
            id: DateTime.now().toString(),
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
