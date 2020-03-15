import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import '../helpers/screen_controller.dart';

class OfflineSignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenController.setProductsOverviewScreenLoading(false);
    ScreenController.setRefreshButton(true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          child: Text(
            'There is no internet connection...',
            style: TextStyle(fontSize: 20),
          ),
          alignment: Alignment.center,
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton.icon(
            onPressed: () async {
              AppSettings.openWIFISettings();
            },
            icon: Icon(Icons.settings),
            label: Text('Turn on Wifi on your phone'))
      ],
    );
  }
}
