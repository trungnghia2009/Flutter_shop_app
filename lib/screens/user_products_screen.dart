import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import 'add_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const String routeName = 'user_products_screen';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
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

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
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
        body: RefreshIndicator(
          onRefresh: _refreshProducts,
          child: Padding(
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
              )),
        ),
      ),
    );
  }
}
