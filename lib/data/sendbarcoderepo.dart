import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:grbarcode/global/settings.dart';

import 'networkerror_helper.dart';

abstract class BarCodeRepository {
  Future<String> sendBarCode(String barCode);
}

class SendBarCode implements BarCodeRepository {
  @override
  Future<String> sendBarCode(String barCode) async {
    final Map _settings = await readPreferences();
    if (_settings['serverAddress'] == '' || _settings['serverKey'] == '') {
      throw NetworkException('Vensligs konfigurer serverinstillingene.');
    }
    print('Address: ${_settings["serverAddress"]}');
    print('Key: ${_settings["serverKey"]}');
    final dio = Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };

    dio.options
      ..baseUrl = 'https://${_settings["serverAddress"]}:6942'
      //  '${_settings["serverAddress"]}:${_settings["serverPort"]}/v1/objects/hosts'
      //
      // ..method =
      ..connectTimeout = 5000
      ..headers = {
        'User-Agent': 'GRBarCode',
        'Accept': 'text/html; charset=utf-8',
        'Content-Type': 'text/html; charset=utf-8',
        'X-API-KEy': '${_settings["serverKey"]}',
      }
      ..responseType = ResponseType.plain;

    final data = '$barCode';
    print(data);
    final response = await dio.post('', data: data);
    return response.toString();
    //  .catchError((e) => throw NetworkException(e));
  }
}
