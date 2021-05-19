import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  // void updateFavorites(String id, Product newProduct) async{
  //   final index = _items.indexWhere((prod) => prod.id == id);
  //   if (index >= 0) {
  //     final uri = Uri.parse(
  //         'https://my-shop-c1620-default-rtdb.firebaseio.com/product/$id.json');
  //     await http.patch(uri,
  //         body: json.encode({
  //           'Favorite': newProduct.isFavorite,
  //         }));
  //     _items[index] = newProduct;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  //
  // }

  Future<void> deleteProduct(String id) async {
    final uri = Uri.parse(
        'https://my-shop-c1620-default-rtdb.firebaseio.com/product/$id.json');
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    var product = _items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners();
    final response = await http.delete(uri);

    if (response.statusCode >= 400) {
      _items.insert(prodIndex, product);
      notifyListeners();
      throw HttpException('some thing went wrong ') ;
    }
    product = null;

  }

  Future<void> fetchAndGetProducts() async {
    final uri = Uri.parse(
        'https://my-shop-c1620-default-rtdb.firebaseio.com/product.json');
    try {
      final response = await http.get(uri);
      final products = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> productsList = [];
      if(products==null){
        return;
      }
      products.forEach((prodId, prodData) {
        productsList.add(Product(
            id: prodId,
            title: prodData['title'],
            price: prodData['price'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite']));
      });
      _items = productsList;
      // for(int i = 0 ; i <= products.length ;i++){
      //   final addedProd = Product(
      //       title: products[i]['title'],
      //       id: products[i]['name'],
      //       description: products[i]['description'],
      //       imageUrl: products[i]['imageUrl'],
      //       price: double.parse(products[i]['price']));
      //   _items.add(addedProd);
      // }

      notifyListeners();

      // print(json.decode(response.body));

    } catch (error) {
      print(error);

      throw error;
    }
  }

  Future<void> addProduct(Product prod) async {
    final uri = Uri.parse(
        'https://my-shop-c1620-default-rtdb.firebaseio.com/product.json');
    try {
      final response = await http.post(
        uri,
        body: json.encode(
          {
            'title': prod.title,
            'description': prod.description,
            'imageUrl': prod.imageUrl,
            'price': prod.price,
            'isFavorite': prod.isFavorite
          },
        ),
      );
      // print(json.decode(response.body)['name']);
      final addedProd = Product(
          title: prod.title,
          id: json.decode(response.body)['name'],
          description: prod.description,
          imageUrl: prod.imageUrl,
          price: prod.price);
      _items.add(addedProd);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      final uri = Uri.parse(
          'https://my-shop-c1620-default-rtdb.firebaseio.com/product/$id.json');
      await http.patch(uri,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavorite':newProduct.isFavorite
          }));
      _items[index] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Product findById(String aid) {
    return _items.firstWhere((prod) => prod.id == aid);
  }

  List<Product> get getFavItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }
}
