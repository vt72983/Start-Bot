import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../env.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  ApiClient({Dio? dio, required SecureStorage secureStorage, Logger? logger})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: Env.apiBaseUrl, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10))),
        _secureStorage = secureStorage,
        _logger = logger ?? Logger();

  final Dio _dio;
  final SecureStorage _secureStorage;
  final Logger _logger;

  Dio get client {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final started = DateTime.now();
          options.extra['__started_at'] = started.millisecondsSinceEpoch;
          final token = await _secureStorage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Debug log of outgoing request (without token)
          _logger.i('HTTP ${options.method} ${options.path} -> BODY: ${_safeBody(options.data)}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          final startedMs = response.requestOptions.extra['__started_at'] as int?;
          final elapsed = startedMs != null
              ? DateTime.now().millisecondsSinceEpoch - startedMs
              : null;
          final status = response.statusCode;
          final method = response.requestOptions.method;
          final path = response.requestOptions.path;
          // Log only non-2xx as warning, 2xx as debug
          final msg = 'HTTP $method $path -> $status in ${elapsed ?? '-'}ms BODY: ${_safeBody(response.data)}';
          if (status != null && status >= 200 && status < 300) {
            _logger.d(msg);
          } else {
            _logger.w(msg);
          }
          handler.next(response);
        },
        onError: (e, handler) async {
          final req = e.requestOptions;
          final startedMs = req.extra['__started_at'] as int?;
          final elapsed = startedMs != null
              ? DateTime.now().millisecondsSinceEpoch - startedMs
              : null;
          final method = req.method;
          final path = req.path;
          final status = e.response?.statusCode;
          final body = _safeBody(e.response?.data);
          // Не логируем токен (ни в заголовках, ни в теле)
          _logger.w('HTTP $method $path -> ${status ?? 'null'} in ${elapsed ?? '-'}ms BODY: $body');
          handler.next(e);
        },
      ),
    );
    return _dio;
  }

  String _safeBody(dynamic data) {
    try {
      if (data == null) return 'null';
      final str = data.toString();
      if (str.length > 500) {
        return str.substring(0, 500) + '...';
      }
      return str;
    } catch (_) {
      return '<unprintable>';
    }
  }
}


