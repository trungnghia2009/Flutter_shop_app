import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/product_adding.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Pink Dress',
//      description: 'A light pink dress - it is pretty hot!',
//      price: 29.99,
//      imageUrl:
//          'https://znews-photo.zadn.vn/w660/Uploaded/cqdhmdxwp/2019_07_09/62256761_147565532983317_1295828558959990778_n_copy.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://anh.eva.vn//upload/2-2015/images/2015-06-23/1435073639-16.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://www.dhresource.com/600x600/f2/albu/g6/M01/5A/24/rBVaR1uNScGAdFerAAYz0o0GkBM254.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://thumbs.dreamstime.com/b/smiling-little-girl-cook-hat-frying-pan-cooking-people-concept-51943804.jpg',
//    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-shop-app-b7959.firebaseio.com/products.json';
    try {
      final respond = await http.get(url);
      print(json.decode(respond.body));
      final extractedData = json.decode(respond.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData
          .forEach((productId, productData) => loadedProducts.add(Product(
                id: productId,
                title: productData['title'],
                description: productData['description'],
                price: productData['price'],
                imageUrl: productData['imageUrl'],
                isFavorite: productData['isFavorite'],
              )));
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // TODO: return Future<void>
  Future<void> addProduct(ProductAdding product) async {
    // TODO: post new product to firebase
    const url = 'https://flutter-shop-app-b7959.firebaseio.com/products.json';
    // TODO: Handle Exception
    try {
      final respond = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      print(json.decode(respond.body));
      final Product newProduct = Product(
        id: json.decode(respond.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct); // add to the beginning
    } catch (error) {
      print(error);
      throw error;
    }

    // TODO: .then mean get the result after post has finished
  }

  Future<void> updateProduct(int index, Product product) async {
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/products/${product.id}.json';
    try {
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
    } catch (error) {
      print(error);
      throw error;
    }

    _items[index] = product;

    notifyListeners();
  }

  Future<void> removeProduct(Product product) async {
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/products/${product.id}.json';
    final existingProductIndex =
        _items.indexWhere((item) => item.id == product.id);
    // TODO: delete local product first
    _items.remove(product);
    notifyListeners();
    final respond = await http.delete(url);
    // TODO: if getting error http request code 4xx, return product to local
    if (respond.statusCode >= 400) {
      _items.insert(existingProductIndex, product);
      notifyListeners();
      throw HttpException(message: 'Could not delete product');
    }
    product = null;
  }

  Future<void> toggleFavoriteById(Product product) async {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/products/${product.id}.json';
    final respond = await http.patch(url,
        body: json.encode({
          'isFavorite': product.isFavorite,
        }));
    print(respond.statusCode);
    if (respond.statusCode >= 400) {
      product.isFavorite = !product.isFavorite;
      notifyListeners();
      throw HttpException(message: 'Could not add favorite');
    }
  }

  bool getFavoriteById(String id) {
    Product product = _items.firstWhere((item) => item.id == id);
    return product.isFavorite;
  }
}
