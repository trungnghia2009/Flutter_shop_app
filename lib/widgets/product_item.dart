import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import 'badge2.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final snackBar = Scaffold.of(context);
    print('ProductItem() rebuil');
    // TODO: not change except for widgets that were wrapped by Consumer<>
    final productData = Provider.of<Product>(context, listen: false);
    final cartData = Provider.of<Cart>(context);
    // TODO: ClipRRect forces the child widget it wraps into a certain shape
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productData);
          },
          child: Image.network(
            productData.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          // TODO: apply Consumer<Product> for IconButton, because this widget only changes on this screen
          leading: Consumer<Product>(
            // TODO: to understand about third argument 'child'
            // TODO: please prefer https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#consumer
            builder: (context, productData, child) => IconButton(
              icon: Icon(productData.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () async {
                print('Favorite rebuil');
                await productData.toggleFavoriteStatus(productData, context);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
          trailing: GestureDetector(
            child: Badge2(
              cartData: cartData,
              productId: productData.id,
            ),
            onTap: () {
              cartData.addItem(
                productData.id,
                productData.price,
                productData.title,
              );
              // TODO: Establish the connection to the nearest Scaffold, the nearest app layout
              // TODO: This have all properties and methods that belong to nearest Scaffold
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added ${productData.title} to cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cartData.removeItemById(productData.id);
                    },
                  ),
                ),
              );
            },
          ),
          backgroundColor: Colors.black54,
        ),
      ),
    );
  }
}
