import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

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
                  Text('Total', style: TextStyle(fontSize: 20)),
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
                  FlatButton(
                    onPressed: () {
                      cartData.totalAmount > 0
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: Text("Make an order ?"),
                                  content:
                                      Text("This will lead you to order page."),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    FlatButton(
                                      child: Text("No"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        Provider.of<Orders>(context,
                                                listen: false)
                                            .addOrder(
                                                cartData.items.values.toList(),
                                                cartData.totalAmount);
                                        Navigator.of(context).pop();
//                                        Navigator.of(context)
//                                            .pushReplacementNamed(
//                                                OrdersScreen.routeName);
                                        cartData.clearCart();
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("There is no item in cart"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                    },
                    child: Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          // TODO: IF were in column, must define height for ListView
          cartData.items.length == 0
              ? Center(child: Text('There is no item in cart!'))
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
