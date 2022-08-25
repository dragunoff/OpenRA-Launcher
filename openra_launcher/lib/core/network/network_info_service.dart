import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfoService {
  Future<bool> get isConnected;
}

class NetworkInfoServiceImpl implements NetworkInfoService {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoServiceImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
