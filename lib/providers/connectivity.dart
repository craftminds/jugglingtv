import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    Connectivity _connectivity = Connectivity();
    _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      InternetConnectionChecker().onStatusChange.listen((status) {
        _isOnline = status == InternetConnectionStatus.connected;
      });
      notifyListeners();
    });
  }
}
