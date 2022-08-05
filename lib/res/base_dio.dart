import 'package:dio/dio.dart';

class BaseDio{
  static BaseDio dio = BaseDio();
  factory BaseDio(){
    return dio;
  }

  static Dio getDio(){
    final dio = Dio();
    return dio;
  }

}