import 'package:flutter/material.dart';
import '../widgets/products_grip.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/theme_type.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = 'products_overview_screen';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isFavoritesOnly = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  void _showDrawer(BuildContext context) {
    _scaffoldKey.currentState.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show all'),
                  value: FilterOptions.All,
                ),
              ],
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.All) {
                    _isFavoritesOnly = false;
                  } else {
                    _isFavoritesOnly = true;
                  }
                });
              },
            ),
            // TODO: add Consumer here, only need Cart provider here
            Consumer<Cart>(
              builder: (_, cartData, ch) => Badge(
                child: ch,
                value: cartData.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
            IconButton(
                icon: Icon(Icons.map),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                })
          ],
        ),
        body: _isLoading
            ? SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
              )
            // TODO: add refresh indicator
            : RefreshIndicator(
                onRefresh: _refreshProducts,
                child: ProductsGrip(
                  showFav: _isFavoritesOnly,
                )),
        drawer: AppDrawer(),
      ),
    );
  }
}
