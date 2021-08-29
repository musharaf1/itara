import 'dart:convert';

/// HTTP Rest API client for Flutter
/// [author:] Praise Emerenini<praisegeek@gmail.com>
/// [license:] MIT

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fs;

import 'Resource.dart';
import 'err.dart';

class Client {
  Dio? _dio;
  final _store = fs.FlutterSecureStorage();
  // final String baseUrl = 'https://devapi.itara.ng/api/v1/';
  final String baseUrl = 'https://api.itarashop.ng/api/v1/';

  Client() : super() {
    String? token;

    this._dio = Dio();

    _dio!.options.baseUrl = baseUrl;
    // _dio!.options.receiveTimeout = 40000;
    // _dio!.options.sendTimeout = 60000;
    // _dio.options.connectTimeout = 40000;

    _dio!.interceptors.clear();

    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          options.headers['Accept'] = 'application/json';

          token = await _store.read(key: 'token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioError error, handler) async {
          /// attempt refresh token if unauthorized
          /// avoid infinit-loop by checking [token]
          if (error.response?.statusCode == 401 && token != null) {
            _dio!.interceptors.requestLock.lock();
            _dio!.interceptors.responseLock.lock();

            RequestOptions? options = error.response!.requestOptions;
            options.headers['Authorization'] = null;

            token = await getToken();
            options.headers['Authorization'] = 'Bearer $token';

            _dio!.interceptors.requestLock.unlock();
            _dio!.interceptors.responseLock.unlock();

            // return _dio.request(path)
            Response res = await _dio!.request(options.path,
                options: Options(
                    method: error.requestOptions.method,
                    headers: options.headers));

            return handler.resolve(res);

            // await _dio!.request(options.path,
            //     options: Options(
            //       method: options.method,
            //       sendTimeout: options.sendTimeout,
            //       receiveTimeout: options.receiveTimeout,
            //       extra: options.extra,
            //       headers: options.headers,
            //       responseType: options.responseType,
            //       contentType: options.contentType,
            //       validateStatus: options.validateStatus,
            //       receiveDataWhenStatusError:
            //           options.receiveDataWhenStatusError,
            //       followRedirects: options.followRedirects,
            //       maxRedirects: options.maxRedirects,
            //       requestEncoder: options.requestEncoder,
            //       responseDecoder: options.responseDecoder,
            //       listFormat: options.listFormat,
            //     ));
            // return handler.next(error);
          } else {
            return handler.next(error);
          }
        },
        // onResponse: (Response response) async {
        //   if(response.statusCode.toString().startsWith('2')) {
        //     await getToken();
        //   }
        // }
      ),
    );
  }

  Future<String?> getToken() async {
    // clear token
    print("+++REFRESHING TOKEN+++");

    await _store.delete(key: 'token');

    // fetch refreshToken and userId
    String? userId = await _store.read(key: 'userId');
    String? refreshToken = await _store.read(key: 'refreshToken');

    var payload = <String, String>{
      "refreshToken": refreshToken!,
      "userId": userId!,
    };

    // call refresh-token endpoint
    final res = await http.post(
      Uri.parse('${this.baseUrl}accounts/refresh-token'),
      body: json.encode(payload),
      headers: {"Content-Type": 'application/json'},
    );
    // print(res.statusCode);
    // print(json.decode(res.body));

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      print(body['data']);

      // save new token to local storage
      await writeTokens(body['data']);
      // print(body['data']['token']);
      return body['data']['token'];
    }

    return null;
  }

  Future<void> writeTokens(Map data) async {
    await _store.write(key: 'token', value: data['token']);
    await _store.write(
        key: 'refreshToken', value: data['refreshToken'].toString());
  }

  void debugError(DioError e) {
    if (e.response != null) {
      print("statusCode: ${e.response!.statusCode}");
      print(e.response!.data);
      print(e.response!.headers);
      print(e.response!.requestOptions);
    } else {
      print(e.error!);
      print(e.message);
    }
  }

  // GET handler
  Future load(Resource resource) async {
    print(resource.url);
    print('Get request');
    // print(resource.queryParameters);
    try {
      print(_dio!.options.baseUrl);
      print(_dio!.options.headers);
      print(_dio!.options.headers['Authorization']);
      final response = await _dio!.get(
        resource.url!,
        queryParameters: resource.queryParameters,
      );
       print(response.requestOptions.headers);
      // print(response);
      return resource.parse!(response.data);
    } on DioError catch (e) {
      if (e.response!.data != null) {
        try {
          var data = e.response!.data['errorMessages'][0];
          await ShowErrors.showErrors(data);
        } on TypeError catch (e) {
          await ShowErrors.showErrors('Some data failed to load');
        }
        // await ShowErrors.showErrors(e.response!.data['errorMessages'][0]);
        // return resource.parse(e.response.data);

        // throw ErrorDescription(e.response!.data['errorMessages'][0]);
      } else {
        await ShowErrors.showErrors('Network Request Error');
        // return resource.parse(e.response.headers.map);
        throw ErrorDescription('Request Error');
      }
    }
  }

  // POST handler
  Future post(Resource resource) async {
    print(resource.url);
    print('Post request');

    try {
      print(_dio!.options.baseUrl);
      print(_dio!.options.headers);
      final response = await _dio!.post(resource.url!,
          data: json.encode(resource.data),
          queryParameters: resource.queryParameters);
      // print(response.data);

      return resource.parse!(response.data);
    } on DioError catch (e) {
      print(e.response!.data);
      debugError(e);

      if (e.response!.data != null) {
        await ShowErrors.showErrors(e.response!.data['errorMessages'][0]);
        // return resource.parse(e.response.data);

       throw ErrorDescription(e.response!.data['errorMessages'][0]);
      } else {
        await ShowErrors.showErrors('Network Request Error');
        // return resource.parse(e.response.headers.map);
        throw ErrorDescription('Request Error');
      }
    }
  }

  // PUT handler
  Future put(Resource resource) async {
    print(resource.url);
    print('Put request');

    try {
      print(_dio!.options.baseUrl);
      print(_dio!.options.headers);
      final response = await _dio!.put(
        resource.url!,
        data: json.encode(resource.data),
      );

      return resource.parse!(response.data);
    } on DioError catch (e) {
      debugError(e);
      if (e.response!.data != null) {
        await ShowErrors.showErrors(e.response!.data['errorMessages'][0]);
        // return resource.parse!(e.response!.data);

        throw ErrorDescription(e.response!.data['errorMessages'][0]);
      } else {
        await ShowErrors.showErrors('Network Request Error');
        return resource.parse!(e.response!.headers.map);
      }
    }
  }

  // DELETE handler
  Future delete(Resource resource) async {
    print(resource.url);
    print('Delete request');

    try {
      print(_dio!.options.headers['Authorization']);
      final response = await _dio!.delete(
        resource.url!,
        data: json.encode(resource.data),
      );
      print(response.requestOptions.headers);

      return resource.parse!(response.data);
    } on DioError catch (e) {
      debugError(e);
      if (e.response!.data != null) {
        await ShowErrors.showErrors(e.response!.data['errorMessages'][0]);
        return resource.parse!(e.response!.data);

        // throw ErrorDescription(e.response.data['errorMessages'][0]);
      } else {
        await ShowErrors.showErrors('Network Request Error');
        return resource.parse!(e.response!.headers.map);
      }
      // return resource.parse(e.response.data);
      // throw ErrorDescription(e.message);

    }
  }

  // TODO: Other methods

}

// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIwOGQ5NDA5YS01NGY4LTQ3Y2YtODQ3Ni1jMWFiNDBlMTY4MDgiLCJ1bmlxdWVfbmFtZSI6ImRjbGFpcmU0NjRAZ21haWwuY29tIiwicm9sZSI6IlVzZXIiLCJuYmYiOjE2MjY2Njc3NjQsImV4cCI6MTYyNjY3NDk2NCwiaWF0IjoxNjI2NjY3NzY0fQ.Bhy7RZAjmxnuIsBn9RRFbBpBImkU4iV_p9_t_tX5Xaw
