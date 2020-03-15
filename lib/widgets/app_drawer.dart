import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shop_app_flutter/widgets/round_icon_button.dart';
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
                    minRadius: 28,
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
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Log Out'),
                  content: Text('Do you really want to log out ?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // TODO: push to homePage, remove all
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false);
                          Provider.of<Auth>(context, listen: false).logout();
                        },
                        child: Text('Yes')),
                  ],
                ),
              );
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
