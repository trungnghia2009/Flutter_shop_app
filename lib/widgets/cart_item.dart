import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/widgets/round_icon_button.dart';
import '../providers/cart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/product_detail_screen.dart';
import '../providers/products.dart';

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
    final productsData = Provider.of<Products>(context, listen: false);
    final cartData = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
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
      // TODO: Focus on showDialog()
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          // TODO: Focus on AlertDialog()
          builder: (ctx) => AlertDialog(
            title: Text('Are your sure ?'),
            content: Text('Do you want to remove this item from the cart ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
              title: GestureDetector(
                child: Text(title),
                onTap: () {
                  Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                      arguments: productsData.findByTitle(title));
                },
              ),
              subtitle:
                  Text('Total: \$${(price * quality).toStringAsFixed(2)}'),
              trailing: Container(
                width: 130,
                child: Row(
                  children: <Widget>[
                    RoundIconButton(
                      onPressed: () {
                        cartData.removeItemById(productID);
                      },
                      icon: FontAwesomeIcons.minus,
                    ),
                    RoundIconButton(
                      onPressed: () {
                        cartData.addItem(productID, price, title);
                      },
                      icon: FontAwesomeIcons.plus,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('$quality x'),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
