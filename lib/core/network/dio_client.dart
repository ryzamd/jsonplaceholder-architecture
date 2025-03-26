import 'package:dio/dio.dart';
import 'package:jsonplaceholder_app/core/constants/api_constants.dart';
import 'package:jsonplaceholder_app/core/errors/exceptions.dart';
import 'package:logger/logger.dart';

class DioClient {
  final Dio _dio;
  final Logger _logger;

  DioClient(this._dio, this._logger) {
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = Duration(seconds: ApiConstants.connectionTimeoutSeconds)
      ..receiveTimeout = Duration(seconds: ApiConstants.receiveTimeoutSeconds)
      ..responseType = ResponseType.json;

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        logPrint: (object) => _logger.d(object.toString()),
      ),
    );
  }

 /// Thực hiện HTTP GET request
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _logger.e('GET request error: $e');
      throw ServerException(
        message: 'Lỗi không xác định khi gọi API',
      );
    }
  }

  Future<dynamic> post(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _logger.e('POST request error: $e');
      throw ServerException(message: "Error: Undefine when call Server");
    }
  }

  Future<dynamic> put(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _logger.e('PUT request error: $e');
      throw ServerException(message: "Error: Undefine when call Server");
    }
  }

  Future<dynamic> delete(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _logger.e('PUT request error: $e');
      throw ServerException(message: "Error: Undefine when call Server");
    }
  }

  void _handleDioError(DioException dioException) {
    String errorMessage;
    int? statusCode;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Kết nối đến server bị timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Gửi yêu cầu đến server bị timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Nhận phản hồi từ server bị timeout';
        break;
      case DioExceptionType.badResponse:
        statusCode = dioException.response?.statusCode;
        errorMessage = _handleStatusCode(statusCode);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Yêu cầu đã bị hủy bỏ';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Không thể kết nối đến server';
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = 'Lỗi không xác định khi gọi API';
        break;
    }

    _logger.e(
      'DioError: ${dioException.message}, StatusCode: $statusCode, ErrorMessage: $errorMessage',
    );

    throw ServerException(message: errorMessage, statusCode: statusCode);
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Yêu cầu không hợp lệ';
      case 401:
        return 'Không được phép truy cập';
      case 403:
        return 'Bị từ chối truy cập';
      case 404:
        return 'Không tìm thấy resource được yêu cầu';
      case 405:
        return 'Phương thức không được hỗ trợ';
      case 500:
        return 'Lỗi server nội bộ';
      case 501:
        return 'Chức năng chưa được triển khai';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Dịch vụ không khả dụng';
      default:
        return 'Lỗi không xác định với status code: $statusCode';
    }
  }
}
