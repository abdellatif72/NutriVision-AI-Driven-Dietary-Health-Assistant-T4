import 'package:afia/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

class RetryOn429Interceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration delay;

  RetryOn429Interceptor({
    required this.dio,
    this.maxRetries = 3,
    this.delay = const Duration(seconds: 15),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 429) {
      final requestOptions = err.requestOptions;
      
      // Store/get the retry attempt inside requestOptions.extra
      final extra = Map<String, dynamic>.from(requestOptions.extra);
      int retryAttempt = (extra['retryAttempt'] as int? ?? 0) + 1;
      
      if (retryAttempt <= maxRetries) {
        extra['retryAttempt'] = retryAttempt;
        requestOptions.extra = extra;
        
        AppLogger.warning(
          'API WARNING: Received 429 Too Many Requests. Retrying request ${requestOptions.path} (Attempt $retryAttempt/$maxRetries) after ${delay.inSeconds}s...',
        );
        
        await Future.delayed(delay);
        
        try {
          // Retry the request using dio.fetch
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryErr) {
          // Pass the retry error down the chain (it will be caught by onError again if it fails with 429)
          return handler.next(retryErr);
        } catch (e) {
          return handler.next(
            DioException(
              requestOptions: requestOptions,
              error: e,
              message: e.toString(),
            ),
          );
        }
      }
    }
    
    super.onError(err, handler);
  }
}
