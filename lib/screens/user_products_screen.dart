import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import 'add_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = 'user_products_screen';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
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
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, index) => ChangeNotifierProvider.value(
              value: productsData.items[index],
              child: UserProductItem(
                productIndex: index,
              ),
            ),
          )),
    );
  }
}
