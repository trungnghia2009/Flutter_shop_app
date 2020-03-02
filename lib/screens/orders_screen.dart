import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = 'orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<bool> _onWillPop() {
    print('action...');
    return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Do you really want to exit the app ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Yes'),
              )
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('My Orders'),
          ),
          drawer: AppDrawer(),
          // TODO: No need to define height for ListView
          body: ordersData.orders.isEmpty
              ? Center(
                  child: Text(
                    'There is no Order !',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (ctx, index) => OrderItem(
                    order: ordersData.orders[index],
                    index: index,
                  ),
                )),
    );
  }
}
