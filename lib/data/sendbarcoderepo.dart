import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

abstract class BarCodeRepository {
  Future<String> sendBarCode(String barCode);
}

class SendBarCode implements BarCodeRepository {
  @override
  Future<String> sendBarCode(String barCode) async {
    final dio = Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };

    dio.options
      ..baseUrl = 'https://10.0.0.102:6942'
      //  '${_settings["serverAddress"]}:${_settings["serverPort"]}/v1/objects/hosts'
      //
      // ..method =
      ..connectTimeout = 5000
      ..headers = {
        'User-Agent': 'GRBarCode',
        'Accept': 'text/html; charset=utf-8',
        'Content-Type': 'text/html; charset=utf-8',
        'X-API-KEy': '7862967551',
      }
      ..responseType = ResponseType.plain;

    final data = '$barCode';
    print(data);
    final response = await dio.post('', data: data);
    return response.toString();
    //  .catchError((e) => throw NetworkException(e));
  }
}
