import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import 'add_product_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = 'user_products_screen';

  Future<bool> _onWillPop(BuildContext context) {
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

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
//    final productsData = Provider.of<Products>(context);
    print('rebuilding .....');
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddProductScreen.routeName);
                })
          ],
        ),
        drawer: AppDrawer(),
        // TODO: show list of Products
        // TODO: add refresh indicator
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? SpinKitFadingCircle(
                  color: Theme.of(context).primaryColor,
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Products>(
                    builder: (ctx, productsData, child) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (_, index) => ChangeNotifierProvider.value(
                          value: productsData.items[index],
                          child: UserProductItem(
                            productIndex: index,
                            product: productsData.items[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
