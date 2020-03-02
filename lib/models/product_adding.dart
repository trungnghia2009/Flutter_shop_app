import 'package:flutter/foundation.dart';

class ProductAdding {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  ProductAdding({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
}

class Edited {
  ProductAdding _editedProduct = ProductAdding(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  ProductAdding get editedProduct {
    return _editedProduct;
  }
}
