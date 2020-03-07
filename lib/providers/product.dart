import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  ScaffoldFeatureController snackBarError(BuildContext context) {
    Scaffold.of(context).hideCurrentSnackBar();
    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not add favorite'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void convertFavorite(Product product) {
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  // TODO: standard for favorite
  Future<void> toggleFavoriteStatus(Product product, BuildContext context,
      String authToken, String userId) async {
    convertFavorite(product);
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/userFavorites/$userId/${product.id}.json?auth=$authToken';
    try {
      // TODO: only use isFavorite => use put
      final respond = await http.put(url, body: json.encode(isFavorite));
      if (respond.statusCode >= 400) {
        print('status code');
        convertFavorite(product);
        snackBarError(context);
      }
    } catch (error) {
      print('catch error');
      product.isFavorite = !product.isFavorite;
      convertFavorite(product);
    }
  }
}
