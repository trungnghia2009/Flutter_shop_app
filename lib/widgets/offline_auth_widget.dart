import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

class OfflineAuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No internet connection'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.signal_wifi_off,
            size: 70,
          ),
          Align(
            child: Text(
              'There is no internet connection',
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.black),
              ),
              onPressed: () async {
                AppSettings.openWIFISettings();
              },
              icon: Icon(Icons.settings),
              label: Text('Go to Wifi settings')),
          FlatButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.black),
              ),
              onPressed: () async {
                AppSettings.openDataRoamingSettings();
              },
              icon: Icon(Icons.settings),
              label: Text('Go to Data Roaming settings'))
        ],
      ),
    );
  }
}
