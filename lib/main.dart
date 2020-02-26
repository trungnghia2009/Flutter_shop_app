import 'package:flutter/material.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'providers/products.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
//      create: (context) => Products(),
      value: Products(),
      child: MaterialApp(
        theme: ThemeData(
          canvasColor: Color.fromRGBO(250, 250, 250, 0.9),
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        title: 'Shop now!!',
        initialRoute: ProductsOverviewScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
