import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  late Dio _dio;
  String? _authToken;

  static const String _baseUrl = 'http://54.241.200.172:8800/setup-ws/api/v1/';
  static const String _uploadEndpoint = 'app/update-app/2';
  static const String _downloadEndpoint = 'app/get-permitted-apps?companyId=2';

  NetworkService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = _authToken;
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  void setToken(String? token) {
    _authToken = token;
  }

  String? getToken() => _authToken;

  void clearToken() {
    _authToken = null;
  }

  Future<Response> uploadFile(File file, {String fileKey = 'file', Map<String, dynamic>? parameters, ProgressCallback? onSendProgress, CancelToken? cancelToken}) async {
    try {
      if (_authToken == null) {
        throw Exception('Token is not set. Please call setToken() first.');
      }

      String fileName = file.path.split('/').last;

      Map<String, dynamic> formDataMap = {
        fileKey: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      };

      if (parameters != null) {
        formDataMap.addAll(parameters);
      }

      FormData formData = FormData.fromMap(formDataMap);
      final response = await _dio.patch(
        _uploadEndpoint,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }


  Future<String> downloadFile(String fileName, {String? fileId, Map<String, dynamic>? queryParameters, ProgressCallback? onReceiveProgress, CancelToken? cancelToken}) async {
    try {
      if (_authToken == null) {
        throw Exception('Token is not set. Please call setToken() first.');
      }

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/$fileName';
      String downloadUrl = _downloadEndpoint;
      if (fileId != null) {
        downloadUrl = '$downloadUrl/$fileId';
      }

      await _dio.download(downloadUrl, savePath, queryParameters: queryParameters, onReceiveProgress: onReceiveProgress, cancelToken: cancelToken);

      print('Download successful: $savePath');
      return savePath;
    } on DioException catch (e) {
      print('Download failed: ${_handleError(e)}');
      throw Exception(_handleError(e));
    } catch (e) {
      print('Download error: $e');
      throw Exception('Download failed: $e');
    }
  }

  Future<String> downloadFileFromUrl(String url, String fileName, {ProgressCallback? onReceiveProgress, CancelToken? cancelToken}) async {
    try {
      if (_authToken == null) {
        throw Exception('Token is not set. Please call setToken() first.');
      }

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/$fileName';

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      print('Download successful: $savePath');
      return savePath;
    } on DioException catch (e) {
      print('Download failed: ${_handleError(e)}');
      throw Exception(_handleError(e));
    } catch (e) {
      print('Download error: $e');
      throw Exception('Download failed: $e');
    }
  }

  String _handleError(DioException error) {
    String errorMessage = '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout - Check your internet connection';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout - File upload is taking too long';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout - File download is taking too long';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleResponseError(
          error.response?.statusCode,
          error.response?.data,
        );
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          errorMessage = 'No internet connection';
        } else {
          errorMessage = 'Network error: ${error.message}';
        }
        break;
      default:
        errorMessage = 'Unknown error occurred';
    }

    return errorMessage;
  }

  String _handleResponseError(int? statusCode, dynamic data) {
    String baseMessage = '';

    switch (statusCode) {
      case 400:
        baseMessage = 'Bad request';
        break;
      case 401:
        baseMessage = 'Unauthorized - Invalid token';
        break;
      case 403:
        baseMessage = 'Forbidden - Access denied';
        break;
      case 404:
        baseMessage = 'File not found';
        break;
      case 413:
        baseMessage = 'File too large';
        break;
      case 500:
        baseMessage = 'Internal server error';
        break;
      case 502:
        baseMessage = 'Bad gateway';
        break;
      case 503:
        baseMessage = 'Service unavailable';
        break;
      default:
        baseMessage = 'Error: $statusCode';
    }

    if (data != null) {
      try {
        if (data is Map && data.containsKey('message')) {
          return '$baseMessage - ${data['message']}';
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }

    return baseMessage;
  }

  /// Get base URL
  String get baseUrl => _baseUrl;

  /// Get upload endpoint
  String get uploadEndpoint => _uploadEndpoint;

  /// Get download endpoint
  String get downloadEndpoint => _downloadEndpoint;
}