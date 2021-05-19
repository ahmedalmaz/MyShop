import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.title,
      @required this.id,
      this.isFavorite = false,
      @required this.description,
      @required this.imageUrl,
      @required this.price});

  Future<void> toggleFavorite() async {
    var oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://my-shop-c1620-default-rtdb.firebaseio.com/product/$id.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {'isFavorite': isFavorite},
        ),
      );
      if(response.statusCode >=400){
        isFavorite = oldFavorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldFavorite;
      notifyListeners();
    }


  }
}
