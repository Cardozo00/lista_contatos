import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lista_contato/repository/back4app_interceptor.dart';

class CustonBack4app {
  final _custonDio = Dio();

  Dio get custonDio => _custonDio;

  CustonBack4app() {
    _custonDio.options.headers["Content-Type"] = "application/json";
    _custonDio.options.baseUrl = dotenv.get("BACK4APPBASEURL");
    _custonDio.interceptors.add(Back4appInterceptor());
  }
}
