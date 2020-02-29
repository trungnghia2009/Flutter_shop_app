import 'package:flutter/foundation.dart';

class ProductForm {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  ProductForm({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
  });
}

class Edited {
  ProductForm _editedProduct = ProductForm(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  ProductForm get editedProduct {
    return _editedProduct;
  }
}
