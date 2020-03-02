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
import 'screens/themes_screen.dart';

enum GlobalTheme {
  purple,
  pink,
  amber,
}

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: Add multi providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          value: ThemeTypes(),
        ),
      ],
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeTypesData = Provider.of<ThemeTypes>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeTypesData.getThemeTypeValue == 3
          ? themeTypesData.getDarkTheme()
          : ThemeData(
              canvasColor: Color.fromRGBO(250, 250, 250, 0.9),
              primarySwatch: themeTypesData.getTheme().primarySwatch,
              accentColor: themeTypesData.getTheme().accentColor,
              errorColor: themeTypesData.getTheme().errorColor,
              fontFamily: 'Lato',
            ),
      title: 'Shop now!!',
      home: ProductsOverviewScreen(),
      routes: {
        ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        CartScreen.routeName: (ctx) => CartScreen(),
        OrdersScreen.routeName: (ctx) => OrdersScreen(),
        UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
        EditProductScreen.routeName: (ctx) => EditProductScreen(),
        AddProductScreen.routeName: (ctx) => AddProductScreen(),
        ThemesScreen.routeName: (ctx) => ThemesScreen(),
      },
    );
  }
}
