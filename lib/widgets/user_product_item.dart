import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../screens/product_detail_screen.dart';
import '../providers/screen_controller.dart';

class UserProductItem extends StatelessWidget {
  final int productIndex;
  final Product product;
  UserProductItem({@required this.productIndex, @required this.product});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final snackBar = Scaffold.of(context);

    return Card(
      elevation: 5,
      child: ListTile(
//        key: ValueKey(productData.id),
        subtitle: Text('Price: \$${product.price}'),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: productIndex);
                },
              ),
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
                              onPressed: () async {
                                Navigator.of(context).pop();
                                try {
                                  await productsData.removeProduct(product);
                                  ScreenController
                                      .setFirstLoadingOnProductsOverviewScreen(
                                          true);
                                  snackBar.showSnackBar(SnackBar(
                                      content: Text('Delete succeeded')));
                                } catch (error) {
                                  snackBar.showSnackBar(
                                    SnackBar(
                                      content: Text('Delete failed'),
                                    ),
                                  );
                                }
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
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: product);
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(product.imageUrl),
          ),
        ),
        title: Text(product.title),
      ),
    );
  }
}
