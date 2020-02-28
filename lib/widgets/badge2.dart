import 'package:flutter/material.dart';
import '../providers/cart.dart';

class Badge2 extends StatelessWidget {
  const Badge2({
    Key key,
    @required this.cartData,
    @required this.productId,
    this.color,
  }) : super(key: key);

  final Cart cartData;
  final String productId;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          child: Icon(
            cartData.getItemCountById(productId) == 0
                ? Icons.add_shopping_cart
                : Icons.shopping_cart,
            color: color == null ? Theme.of(context).accentColor : color,
          ),
        ),
        cartData.getItemCountById(productId) == 0
            ? Container()
            : Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  // color: Theme.of(context).accentColor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).accentColor,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    cartData.getItemCountById(productId).toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
