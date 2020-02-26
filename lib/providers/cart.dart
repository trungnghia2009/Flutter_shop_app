import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quality;
  final double price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quality,
    @required this.price,
  });
}

class Cart {
  Map<String, CartItem> _items;
  Map<String, CartItem> get items {
    return {...items};
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quality: existingCartItem.quality + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quality: 1,
              ));
    }
  }
}
