class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = "Exception: Cannot find cache data"});
}

class NetWorkException implements Exception {
  final String message;

  NetWorkException({this.message = "Cannot connect to network"});
}

class ParseException implements Exception {
  final String message;
  final dynamic error;

  ParseException({required this.message, this.error});
}
