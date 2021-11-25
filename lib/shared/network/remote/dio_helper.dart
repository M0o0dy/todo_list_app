import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static late Dio dio;

  static init(){
    dio = Dio(

        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          receiveDataWhenStatusError: true,
          connectTimeout: 5000,
          receiveTimeout: 3000,

        ),

    );

  }
  static Future<Response> getData({
    required String url,
     Map<String, dynamic>?query,
    String lang = 'en',
    String? token,
  }) async {

    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.get(url,queryParameters: query, )
        .catchError((error){print('error is ${error.toString()}');});

  }


  static Future<Response> postData({
    required String url,
    required Map<String, dynamic>data,
     Map<String, dynamic>?query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.post(url,queryParameters: query,data: data, )
        .catchError((error){print('error is ${error.toString()}');});

  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic>data,
    Map<String, dynamic>?query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.put(url,queryParameters: query,data: data, )
        .catchError((error){print('error is ${error.toString()}');});

  }
}