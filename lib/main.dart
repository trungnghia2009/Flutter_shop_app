import 'package:flutter/material.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'providers/products.dart';
import 'package:provider/provider.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'screens/orders_screen.dart';
import 'package:flutter/services.dart';
import 'screens/user_products_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/add_product_screen.dart';
import 'providers/theme_type.dart';
import 'providers/auth.dart';
import 'screens/settings_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_detail_screen.dart';
import 'providers/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/connectivity_service.dart';
import 'enums/connectivity_status.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    var themeType = prefs.getInt('themeValue') ?? 0;
    runApp(
      MultiProvider(
        // TODO: add StreamProvider
        providers: [
          StreamProvider<ConnectivityStatus>(
            create: (ctx) =>
                ConnectivityService().connectionStatusController.stream,
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          // TODO: theme...
          ChangeNotifierProvider(
            create: (ctx) => ThemeTypes(themeType),
          ),
          ChangeNotifierProxyProvider<Auth, Avatar>(
            update: (_, auth, avatar) =>
                avatar..updateToken(auth.token, auth.userId),
            create: (ctx) => Avatar(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (_, auth, products) =>
                products..updateToken(auth.token, auth.userId),
            create: (ctx) => Products(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (_, auth, orders) =>
                orders..updateToken(auth.token, auth.userId),
            create: (ctx) => Orders(),
          ),
        ],
        // TODO: ensure that MyMaterialApp is rebuild whenever Auth change
        child: MyMaterialApp(),
      ),
    );
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeTypesData = Provider.of<ThemeTypes>(context);

    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeTypesData.getThemeTypeValue == 3
            ? themeTypesData.getDarkTheme()
            : ThemeData(
                canvasColor: Color.fromRGBO(250, 250, 250, 0.9),
                primarySwatch: themeTypesData.getTheme().primarySwatch,
                accentColor: themeTypesData.getTheme().accentColor,
                errorColor: themeTypesData.getTheme().errorColor,
                buttonColor: themeTypesData.getTheme().buttonColor,
                fontFamily: 'Lato',
              ),
        title: 'Shop now!!',
        home: auth.isAuth
            ? ProductsOverviewScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(),
              ),
        routes: {
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          AddProductScreen.routeName: (ctx) => AddProductScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          UserDetailScreen.routeName: (ctx) => UserDetailScreen(),
        },
      ),
    );
  }
}
