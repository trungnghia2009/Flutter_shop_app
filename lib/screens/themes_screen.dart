import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/theme_type.dart';
import '../widgets/app_drawer.dart';

class ThemesScreen extends StatelessWidget {
  static const String routeName = 'themes_screen';

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

    final themesData = Provider.of<ThemeTypes>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Theme Setting'),
          ),
          drawer: AppDrawer(),
          body: Column(
            children: <Widget>[
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Theme',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            RadioListTile(
                              title: Text('Purple Theme'),
                              value: 0,
                              groupValue: themesData.getThemeTypeValue,
                              onChanged: (value) {
                                themesData.setThemeTypeValue(value);
                              },
                            ),
                            RadioListTile(
                              title: Text('Pink Theme'),
                              value: 1,
                              groupValue: themesData.getThemeTypeValue,
                              onChanged: (value) {
                                themesData.setThemeTypeValue(value);
                              },
                            ),
                            RadioListTile(
                              title: Text('Blue Theme'),
                              value: 2,
                              groupValue: themesData.getThemeTypeValue,
                              onChanged: (value) {
                                themesData.setThemeTypeValue(value);
                              },
                            ),
                            RadioListTile(
                              title: Text('Dark Theme'),
                              value: 3,
                              groupValue: themesData.getThemeTypeValue,
                              onChanged: (value) {
                                themesData.setThemeTypeValue(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
