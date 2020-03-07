import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart' show Cart;
import 'cart_screen.dart';
import '../widgets/round_icon_button.dart';
import '../widgets/badge2.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = 'products_detail_screen';
  @override
  Widget build(BuildContext context) {
    print('ProductDetailScreen() rebuild');
    final product = ModalRoute.of(context).settings.arguments as Product;
    final authData = Provider.of<Auth>(context, listen: false);
    // TODO: make sure this page do not rebuild when products data change, adding 'listen: false'

    final cartData = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (context, cartData, ch) => Badge(
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 240,
                    ),
                    Center(
                      child: Container(
                        height: 60,
                        width: 350,
                        child: Card(
                          color: Colors.black54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Consumer<Products>(
                                builder: (context, productsData, child) =>
                                    IconButton(
                                  icon: Icon(
                                    productsData.getFavoriteById(product.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await productsData.toggleFavoriteById(
                                          product, authData.userId);
                                    } catch (error) {
                                      print(error);
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Could not add favorite'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              RoundIconButton(
                                onPressed: () {
                                  print('--');
                                  cartData.removeItemById(product.id);
                                },
                                icon: FontAwesomeIcons.minus,
                              ),
                              Consumer<Cart>(
                                builder: (_, cartData, child) => Badge2(
                                  cartData: cartData,
                                  productId: product.id,
                                  color: Colors.white,
                                ),
                              ),
                              RoundIconButton(
                                onPressed: () {
                                  print('++');
                                  cartData.addItem(
                                      product.id, product.price, product.title);
                                },
                                icon: FontAwesomeIcons.plus,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: TextStyle(
                fontSize: 40,
                color: Colors.blueGrey,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              child: Text(
                '${product.description}',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
