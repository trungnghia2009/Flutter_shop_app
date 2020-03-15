import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import '../enums/connectivity_status.dart';
import '../providers/products.dart';

class ConnectivityService with ChangeNotifier {
  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    // Subscribe to the connectivity Changed Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t

      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile) {
      return ConnectivityStatus.Cellular;
    } else if (result == ConnectivityResult.wifi) {
      return ConnectivityStatus.WiFi;
    } else if (result == ConnectivityResult.none) {
      return ConnectivityStatus.Offline;
    } else {
      return ConnectivityStatus.Offline;
    }
  }
}
