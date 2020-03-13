import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import 'add_product_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/screen_controller.dart';

class UserProductsScreen extends StatefulWidget {
  static const String routeName = 'user_products_screen';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
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
  void initState() {
    super.initState();
    if (ScreenController.firstLoadingOnUserProductsScreen) {
      setState(() {
        print('state1 .....');
        ScreenController.setUserProductsScreenLoading(true);
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(true)
          .then((_) {
        print('state2 .....');
        setState(() {
          ScreenController.setUserProductsScreenLoading(false);
          ScreenController.setFirstLoadingOnUserProductsScreen(false);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    final productsData = Provider.of<Products>(context);
    print('UserProductsScreen() rebuilding .....');
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
        body: ScreenController.userProductsScreenLoading
            ? SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, userProductsData, child) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: userProductsData.userItems.length,
                      itemBuilder: (_, index) => UserProductItem(
                        productIndex: index,
                        product: userProductsData.userItems[index],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
