import 'package:flutter/material.dart';
import '../providers/theme_type.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({
    Key key,
    @required this.themesData,
  }) : super(key: key);

  final ThemeTypes themesData;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
