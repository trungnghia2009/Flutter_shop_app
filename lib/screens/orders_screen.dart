import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    print('1');
    _isLoading = true;

    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        print('2');
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshOrders() async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    print('run build()');
    final ordersData = Provider.of<Orders>(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Orders'),
          ),
          drawer: AppDrawer(),
          // TODO: No need to define height for ListView
          // TODO: using future builder
          // TODO: an alternative https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/15103292
          body: _isLoading
              ? SpinKitFadingCircle(
                  color: Theme.of(context).primaryColor,
                )
              : (ordersData.orders.length == 0
                  ? Center(
                      child: Text(
                        'There is no order ...',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshOrders,
                      child: ListView.builder(
                        itemCount: ordersData.orders.length,
                        itemBuilder: (ctx, index) => OrderItem(
                          order: ordersData.orders[index],
                          index: index,
                        ),
                      ),
                    )),
        ));
  }
}
