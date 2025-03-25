/// Các hằng số liên quan đến API
class ApiConstants {
  /// Base URL của JSONPlaceholder API
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  /// Endpoints
  static const String posts = '/posts';
  static const String comments = '/comments';
  static const String albums = '/albums';
  static const String photos = '/photos';
  static const String todos = '/todos';
  static const String users = '/users';
  
  /// Timeout duration cho các request (đơn vị: milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}