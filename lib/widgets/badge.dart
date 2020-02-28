import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        cartData.itemCount == 0
            ? Container()
            : Positioned(
                right: 5,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  // color: Theme.of(context).accentColor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:
                        color != null ? color : Theme.of(context).accentColor,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
