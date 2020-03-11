import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  String _authToken;
  String _userId;
  void updateToken(String tokenValue, String userIdValue) {
    _authToken = tokenValue;
    _userId = userIdValue;
  }

  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    DateTime tempTime = DateTime.now();

    // TODO: Need to add Exception handling
    final respond = await http.post(url,
        body: json.encode({
          'dateTime': tempTime.toIso8601String(),
          'amount': total,
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'quality': cartProduct.quality,
                    'price': cartProduct.price,
                  })
              .toList()
        }));
    if (total > 0)
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(respond.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: tempTime,
          ));
  }

  // TODO: set filterByUserId is optional
  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final respond = await http.get(url);
    print(json.decode(respond.body));
    final extractedData = json.decode(respond.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];

    if (extractedData == null) {
      _orders = [];
      return;
    }
    extractedData.forEach((orderId, orderData) {
      // TODO: need to remember at List<dynamic>
      return loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quality: item['quality'],
                  price: item['price'],
                ))
            .toList(),
      ));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> removeOrder(String orderId) async {
    final url =
        'https://flutter-shop-app-b7959.firebaseio.com/orders/$_userId/$orderId.json?auth=$_authToken';
    final respond = await http.delete(url);
    print(jsonDecode(respond.body));
    final removeOrder = _orders.indexWhere((order) => order.id == orderId);
    _orders.removeAt(removeOrder);
    notifyListeners();
  }
}
