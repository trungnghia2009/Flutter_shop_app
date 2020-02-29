import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../screens/product_detail_screen.dart';

class UserProductItem extends StatelessWidget {
  final int productIndex;
  UserProductItem({@required this.productIndex});
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context);
    final productsData = Provider.of<Products>(context);
    return Card(
      elevation: 5,
      child: ListTile(
//        key: ValueKey(productData.id),
        subtitle: Text('Price: \$${productData.price}'),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditProductScreen.routeName,
                        arguments: productIndex);
                  }),
              IconButton(
                  icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Product"),
                          content: Text(
                              "Do you realy want to delete this product ?"),
                          actions: <Widget>[
                            // usually buttons at the bottom of the dialog
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Yes"),
                              onPressed: () {
                                productsData.removeItem(productIndex);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productData.id);
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(productData.imageUrl),
          ),
        ),
        title: Text(productData.title),
      ),
    );
  }
}
