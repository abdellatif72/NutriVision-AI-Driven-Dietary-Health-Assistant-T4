import 'package:afia/core/error/exceptions.dart';
import 'package:afia/core/network/retry_on_429_interceptor.dart';
import 'package:afia/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({Dio? dio}) {
    _dio = dio ?? Dio();
    _configureDio();
  }

  Dio get dio => _dio;

  void _configureDio() {
    _dio.options
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 15)
      ..sendTimeout = const Duration(seconds: 15)
      ..headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

    _dio.interceptors.add(RetryOn429Interceptor(dio: _dio));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.info('API REQUEST [${options.method}] => Path: ${options.path}');
          if (options.data != null) {
            AppLogger.debug('Request Data: ${options.data}');
          }
          if (options.queryParameters.isNotEmpty) {
            AppLogger.debug('Query Params: ${options.queryParameters}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('API RESPONSE [${response.statusCode}] => Path: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          AppLogger.error(
            'API ERROR [${error.response?.statusCode ?? "No Status Code"}] => Path: ${error.requestOptions.path}',
            error,
            error.stackTrace,
          );
          
          // Map Dio errors or timeouts to ServerException
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.connectionError) {
            return handler.next(
              DioException(
                requestOptions: error.requestOptions,
                error: ServerException(),
                type: error.type,
                message: 'Connection timed out. Please check your internet connection and try again.',
              ),
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}
