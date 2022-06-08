import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as IO;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {

  /// GET CALL
  static Future<dynamic> get(
      String url, dynamic parameters, bool isTokenRequired) async {
    try {
      Dio dio = await _dioClient(isTokenRequired);
      Response response = await dio.get(url, queryParameters: parameters);
      // print(response);
      return response;
      // return _response(response);
    } on DioError catch (dioError) {
      // _dioErrorCheck(dioError);
      return _response(dioError.response!);
    } catch (e) {
      print('Something went wrong : $e');
    }
  }

  /// GET CALL JS Object
  static Future<dynamic> getList(
      String url, dynamic parameters, bool isTokenRequired) async {
    try {
      Dio dio = await _dioClient(isTokenRequired);
      Response response = await dio.get(url, queryParameters: Map<String, dynamic>());
      // print(response);
      return response.data;
      // return _response(response);
    } on DioError catch (dioError) {
      // _dioErrorCheck(dioError);
      return _response(dioError.response!);
    } catch (e) {
      print('Something went wrong : $e');
    }
  }

  /// POST CALL
  static Future<dynamic> post(
      String url, dynamic params, dynamic body, bool isTokenRequired) async {
    try {
      Dio dio = await _dioClient(isTokenRequired);
      Response response =
      await dio.post(url, queryParameters: params, data: body);
      return _response(response);
    } on DioError catch (dioError) {
      // _dioErrorCheck(dioError);
      return _response(dioError.response!);
    } catch (e) {
      print('Something went wrong : $e');
    }

    // try {
    //   Dio dio = await _dioClient(isTokenRequired);
    //   Response response =
    //   await dio.post(url, queryParameters: params, data: body);
    //   return _response(response);
    // } catch (e) {
    //   throw e;
    // }

  }

  /// UPDATE CALL
  static Future<dynamic> put(
      String url, dynamic params, dynamic body, bool isTokenRequired) async {
    try {
      Dio dio = await _dioClient(isTokenRequired);
      Response response =
      await dio.put(url, queryParameters: params, data: body);
      return _response(response);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE CALL
  static Future<dynamic> delete(
      String url, dynamic params, dynamic body, bool isTokenRequired) async {
    try {
      Dio dio = await _dioClient(isTokenRequired);
      Response response =
      await dio.delete(url, queryParameters: params, data: body);
      return _response(response);
    } catch (e) {
      throw e;
    }
  }

  /// POST CALL with Files
  static Future<dynamic> upload(
      String url, dynamic params, dynamic body, bool isTokenRequired) async {
    try {
      Dio dio = await _dioClient(isTokenRequired);
      Response response = await dio.post(
        url,
        queryParameters: params,
        data: FormData.fromMap(body),
      );
      return _response(response);
    } on DioError catch (dioError) {
      // _dioErrorCheck(dioError);
      return _response(dioError.response!);
    } catch (e) {
      print('Something went wrong : $e');
    }
  }

  /// Dio Error Checking
  static _dioErrorCheck(DioError dioError) async {
    if (dioError.type == DioErrorType.response) {
      switch (dioError.response!.statusCode) {
        case 404:
          print('400 - Not found');
          break;
        case 401:
         print('401 - Unauthorized.');
          break;
        case 500:
         print('500 - Internal Server Error.');
          break;
        case 501:
         print('501 -  Not Implemented Server Error.');
          break;
        case 502:
         print('502 -  Bad Gateway Server Error.');
          break;
        default:
         print('${dioError.response!.statusCode} - Something went wrong while trying to connect with the server');
          break;
      }
    } else if (dioError.type == DioErrorType.other) {
     print( 'Please check your internet connection. Try again switching to a different connection');
    }
  }


  /// CLIENT
  static Future<Dio> _dioClient(bool isTokenRequired) async {
    String token = "";
    if (isTokenRequired) {
      token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjU0NzEzNTM5LCJpYXQiOjE2NTQ3MTMyMzksImp0aSI6ImM5MGFlMWJjN2IwYjRjZjdiNDNiMWE4OWZmMzdmNzg4IiwidXNlcl9pZCI6MX0.KEbpUwCUaY0NI8OLoNfM_Ph0RzM6FMEXDqESNEXN0Mk";
    }
    Dio dio = Dio(await _options(token, isTokenRequired));
    // dio.interceptors.add(DioFirebasePerformanceInterceptor());

    dio.interceptors.add(PrettyDioLogger(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90));

    if(!kIsWeb){
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (IO.HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    return dio;
  }

  static Future<BaseOptions> _options(
      String token, bool isTokenRequired) async {
    String appName = "CrossFit";
    String versionCode = "0.0.1";

    var header = {
      'app-name': appName,
      'version-code': versionCode,
      'Accept': 'application/json'
    };

    if (isTokenRequired) {
      header['Authorization'] = 'Bearer $token';
    }

    return BaseOptions(
      connectTimeout: 50000,
      receiveTimeout: 50000,
      headers: header,
    );
  }

  /// Response Parser
  static dynamic _response(Response response) {
    var responseJson = json.decode(response.toString());
    return responseJson;
  }
  /// Response Parser for Javascript Object
  static dynamic _responseJS(Response response) {
    print(const JsonEncoder.withIndent(" ").convert(const JsonDecoder().convert(response.toString())));
    return const JsonEncoder.withIndent(" ").convert(const JsonDecoder().convert(response.toString()));
    // return response;
  }

}