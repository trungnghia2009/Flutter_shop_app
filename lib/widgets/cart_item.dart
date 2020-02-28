import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quality;
  final String productID;
  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quality,
      @required this.productID});

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.all(20),
      ),
      movementDuration: Duration(milliseconds: 200),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cartData.removeItem(productID);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  // TODO: focus on FittedBox, fit child into the box
                  child: FittedBox(child: Text('\$$price')),
                ),
              ),
              title: Text(title),
              subtitle:
                  Text('Total: \$${(price * quality).toStringAsFixed(2)}'),
              trailing: Text('$quality x')),
        ),
      ),
    );
  }
}
