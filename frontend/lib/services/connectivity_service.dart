import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<bool> isOnline() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
  }
}
