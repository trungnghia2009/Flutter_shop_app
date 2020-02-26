import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('ProductItem() rebuil');
    // TODO: not change except for widgets that were wrapped by Consumer<>
    final productData = Provider.of<Product>(context, listen: false);
    // TODO: ClipRRect forces the child widget it wraps into a certain shape
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productData.id);
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
              onPressed: () {
                print('IconButton() rebuil');
                productData.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),

          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black54,
        ),
      ),
    );
  }
}