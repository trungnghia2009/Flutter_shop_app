import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = 'orders_screen';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
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
              ));
  }
}
