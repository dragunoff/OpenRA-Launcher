import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract class HttpClientService {
  Future<String> read(Uri url, {Map<String, String>? headers});

  void close();
}

@LazySingleton(as: HttpClientService)
class HttpClientServiceImpl implements HttpClientService {
  static http.Client _createClient() => http.Client();

  http.Client _client = _createClient();

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    return _client.read(url, headers: headers);
  }

  @override
  void close() {
    _client.close();
    _client = _createClient();
  }
}
