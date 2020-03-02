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

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int totalItemsInCart = 0;
    _items.forEach((_, item) => totalItemsInCart += item.quality);
    return totalItemsInCart;
  }

  int getItemCountById(String productId) {
    return _items.containsKey(productId) ? _items[productId].quality : 0;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((_, item) => total += item.quality * item.price);
    return total;
  }

  bool checkQuality(String productId) {
    bool isQuality = false;
    if (_items.containsKey(productId)) {
      isQuality = true;
    }
    return isQuality;
  }

  void removeItemById(String productId) {
    if (_items.containsKey(productId) && _items[productId].quality != 0) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quality: existingCartItem.quality - 1,
                price: existingCartItem.price,
              ));
    }
    if (_items.containsKey(productId) && _items[productId].quality == 0)
      _items.remove(productId);
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    // TODO: containsKey cannot be called on null, must initialize _items as empty
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
    notifyListeners();
  }

  // TODO: update price
  void updatePriceIfProductAlreadyAdded(String productId, double newPrice) {
    if (_items[productId] != null) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: newPrice,
          quality: existingCartItem.quality,
        ),
      );
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  var isFavorite = false;

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
