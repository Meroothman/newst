import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/network/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      // If we can't check, assume we're connected and let the request fail
      return true;
    }
  }
}