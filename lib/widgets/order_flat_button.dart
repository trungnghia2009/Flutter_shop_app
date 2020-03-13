import '../providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../providers/screen_controller.dart';

class OrderFlatButton extends StatefulWidget {
  const OrderFlatButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderFlatButtonState createState() => _OrderFlatButtonState();
}

class _OrderFlatButtonState extends State<OrderFlatButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : FlatButton(
            onPressed: () {
              widget.cartData.totalAmount > 0
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          title: Text("Make an order ?"),
                          content: Text("This will lead you to order page."),
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
                              onPressed: () async {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isLoading = true;
                                });
                                await Provider.of<Orders>(context,
                                        listen: false)
                                    .addOrder(
                                        widget.cartData.items.values.toList(),
                                        widget.cartData.totalAmount)
                                    .then((_) {
                                  ScreenController
                                      .setFirstLoadingOnOrdersScreen(true);
                                });
                                widget.cartData.clearCart();

                                setState(() {
                                  _isLoading = false;
                                });
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
                          title: new Text("There is no item in cart!"),
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
            textColor: Theme.of(context).buttonColor,
          );
  }
}
