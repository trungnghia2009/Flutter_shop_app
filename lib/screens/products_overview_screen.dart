import 'package:flutter/material.dart';
import '../widgets/products_grip.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/avatar.dart';
import '../helpers/screen_controller.dart';
import '../enums/connectivity_status.dart';
import '../widgets/offline_signIn_widget.dart';
import '../widgets/refresh_button.dart';

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
  var _isSearch = false;

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
  void initState() {
    super.initState();

    // TODO: Controller page loading
    if (ScreenController.firstLoadingOnProductsOverviewScreen) {
      setState(() {
        print('in setState().................................');
        ScreenController.setProductsOverviewScreenLoading(true);
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        Provider.of<Avatar>(context, listen: false).fetchAvatarUrl();
      }).then((_) {
        setState(() {
          ScreenController.setProductsOverviewScreenLoading(false);
          ScreenController.setFirstLoadingOnProductsOverviewScreen(false);
        });
      });
    }
  }

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    await Provider.of<Avatar>(context, listen: false).fetchAvatarUrl();
  }

  @override
  Widget build(BuildContext context) {
    print('ProductsOverviewScreen() build');
    final productsData = Provider.of<Products>(context, listen: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: _isSearch
              ? TextField(
                  autofocus: true,
                  onChanged: (title) {
                    setState(() {
                      productsData.selectProductByTitle(title);
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Enter product title",
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                )
              : Text('G-Shop'),
          actions: <Widget>[
            IconButton(
                icon: !_isSearch ? Icon(Icons.search) : Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    _isSearch = !_isSearch;
                    if (productsData.fullSearchList != null)
                      productsData.returnFullProduct();
                  });
                }),

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
          ],
        ),

        // TODO: add checking connection
        body: (Provider.of<ConnectivityStatus>(context) ==
                ConnectivityStatus.Offline)
            ? OfflineSignInWidget()
            : (ScreenController.productsOverviewScreenLoading
                ? SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                  )
                // TODO: add auto refresh indicator
                : (!ScreenController.autoRefresh
                    ? RefreshIndicator(
                        onRefresh: _refreshProducts,
                        child: ProductsGrip(
                          showFav: _isFavoritesOnly,
                        ))
                    : FutureBuilder(
                        future: _refreshProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SpinKitFadingCircle(
                              color: Theme.of(context).primaryColor,
                            );
                          } else {
                            ScreenController.setAutoRefresh(false);
                            return ProductsGrip(
                              showFav: _isFavoritesOnly,
                            );
                          }
                        },
                      ))),
        drawer: _isSearch ? null : AppDrawer(),
      ),
    );
  }
}
