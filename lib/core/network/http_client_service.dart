import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract class HttpClientService {
  Future<String> read(Uri url, {Map<String, String>? headers});
}

@LazySingleton(as: HttpClientService)
class HttpClientServiceImpl implements HttpClientService {
  final http.Client _client = http.Client();

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    return _client.read(url, headers: headers);
  }
}
