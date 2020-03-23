import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/product_adding.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import '../helpers/screen_controller.dart';
import 'dart:async';

class Products with ChangeNotifier {
  String _authToken;
  String _userId;

  void updateToken(String tokenValue, String userIdValue) {
    _authToken = tokenValue;
    _userId = userIdValue;
  }

  List<Product> _items = [];
  List<Product> _userItems = [];
  List<Product> _fullSearchList;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get userItems {
    return [..._userItems];
  }

  List<Product> get fullSearchList {
    return _fullSearchList;
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findByTitle(String title) {
    return _items.firstWhere((item) => item.title == title);
  }

  // TODO: make filterByUser is optional argument, you can adjust the value
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$_userId"' : '';
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/products.json?auth=$_authToken$filterString';
    try {
      final respond = await http.get(url);
      print(json.decode(respond.body));
      final extractedData = json.decode(respond.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final favoriteUrl =
          'https://flutter-shop-app-b7959.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken';
      final favoriteRespond = await http.get(favoriteUrl);
      final favoriteData = json.decode(favoriteRespond.body);

      final List<Product> loadedProducts = [];
      extractedData
          .forEach((productId, productData) => loadedProducts.add(Product(
                id: productId,
                title: productData['title'],
                description: productData['description'],
                price: productData['price'],
                imageUrl: productData['imageUrl'],
                isFavorite: favoriteData == null
                    ? false
                    : favoriteData[productId] ?? false,
              )));
      if (filterByUser) {
        _userItems = loadedProducts;
      } else {
        _items = loadedProducts;
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // TODO: return Future<void>
  Future<void> addProduct(ProductAdding product) async {
    // TODO: post new product to firebase
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/products.json?auth=$_authToken';
    // TODO: Handle Exception
    try {
      final respond = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': _userId,
          }));
      final Product newProduct = Product(
        id: json.decode(respond.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct); // add to the beginning
    } catch (error) {
      throw error;
    }

    // TODO: .then mean get the result after post has finished
  }

  Future<void> updateProduct(int index, Product product) async {
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/products/${product.id}.json?auth=$_authToken';
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
        'https://flutter-shop-app-b7959.firebaseio.com/products/${product.id}.json?auth=$_authToken';
    final existingProductIndex =
        _userItems.indexWhere((item) => item.id == product.id);
    // TODO: delete local product first
    _userItems.remove(product);
    notifyListeners();
    final respond = await http.delete(url);
    ScreenController.setFirstLoadingOnProductsOverviewScreen(true);
    // TODO: if getting error http request code 4xx, return product to local
    if (respond.statusCode >= 400) {
      _userItems.insert(existingProductIndex, product);
      notifyListeners();
      throw HttpException(message: 'Could not delete product');
    }
    product = null;
  }

  Future<void> toggleFavoriteById(Product product, String userId) async {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/userFavorites/$userId/${product.id}.json?auth=$_authToken';
    final respond = await http.put(url,
        body: json.encode(
          product.isFavorite,
        ));
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

  int _searchCount = 0;
  void selectProductByTitle(String title) {
    title = title.toLowerCase();
    if (_searchCount == 0) {
      _fullSearchList = _items;
    } else {
      _items = _fullSearchList;
    }

    List<Product> temp = [];
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].title.toLowerCase().contains(title)) {
        temp.add(_items[i]);
      }
    }
    _items = temp;
    _searchCount++;
    notifyListeners();
  }

  void returnFullProduct() {
    _items = _fullSearchList;
  }

  bool isStream = true;
  Stream refreshPageAfterCertainTime(int second) async* {
    if (isStream) {
      print('streaming.....................................');
      while (true) {
        await Future.delayed(Duration(seconds: second));
        await fetchAndSetProducts();
        isStream = false;
      }
    }
  }
}
