import 'package:flutter/material.dart';
import '../screens/products_overview_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            // TODO: ignore back button
            automaticallyImplyLeading: false,
          ),
          ListTileWidget(
            icon: Icons.shop,
            label: 'Shop',
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTileWidget(
            icon: Icons.payment,
            label: 'Orders',
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTileWidget(
            icon: Icons.edit,
            label: 'Manage Products',
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onTap;
  ListTileWidget({
    @required this.label,
    @required this.onTap,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: 20),
      ),
      onTap: onTap,
    );
  }
}
