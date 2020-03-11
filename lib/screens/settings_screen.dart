import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_type.dart';
import '../widgets/app_drawer.dart';
import '../widgets/theme_settings.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = 'settings_screen';

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() {
      print('action...');
      return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Do you really want to exit the app ?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes'),
                )
              ],
            ),
          ) ??
          false;
    }

    final themesData = Provider.of<ThemeTypes>(context, listen: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
            actions: <Widget>[
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    themesData.saveTheme().then((_) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Saved theme'),
                        duration: Duration(seconds: 2),
                      ));
                    });
                  },
                ),
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: Column(
            children: <Widget>[
              ThemeSettings(themesData: themesData),
            ],
          )),
    );
  }
}
