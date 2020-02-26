import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = 'products_detail_screen';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // TODO: make sure this page do not rebuild when products data change, adding 'listen: false'
    final productsData = Provider.of<Products>(context, listen: false);
    final product = productsData.findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
