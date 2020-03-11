import 'package:flutter/material.dart';
import '../screens/products_overview_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/user_detail_screen.dart';
import '../helpers/path.dart';
import '../providers/avatar.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avatar = Provider.of<Avatar>(context, listen: false);
    print('AppDrawer rebuild ...');
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('G-Shop'),
            // TODO: ignore back button
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: avatar.avatarUrl == null
                        ? AssetImage(Path.avatarImageDefault)
                        : NetworkImage(avatar.avatarUrl),
                    minRadius: 25,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(UserDetailScreen.routeName);
                  },
                ),
              ),
            ],
          ),
          ListTileWidget(
            icon: Icons.settings,
            label: 'App Settings',
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SettingsScreen.routeName);
            },
          ),
          Divider(),
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
          Divider(),
          ListTileWidget(
            label: 'Log Out',
            onTap: () {
              Navigator.of(context).pop();
              // TODO: push to homePage
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            icon: Icons.close,
          )
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
