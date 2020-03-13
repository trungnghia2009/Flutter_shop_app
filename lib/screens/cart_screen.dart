import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../widgets/order_flat_button.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'cart_screen';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: const TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: OrderFlatButton(cartData: cartData),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          // TODO: IF were in column, must define height for ListView
          cartData.items.length == 0
              ? Center(
                  child: Text(
                  'There is no item in cart!',
                  style: TextStyle(fontSize: 18),
                ))
              : Expanded(
                  child: ListView.builder(
                    itemCount: cartData.items.length,
                    itemBuilder: (context, index) => CartItem(
                      // TODO: transform cartData to list
                      id: cartData.items.values.toList()[index].id,
                      title: cartData.items.values.toList()[index].title,
                      price: cartData.items.values.toList()[index].price,
                      quality: cartData.items.values.toList()[index].quality,
                      productID: cartData.items.keys.toList()[index],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
