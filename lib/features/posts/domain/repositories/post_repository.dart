
import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_app/core/errors/failures.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';

/// Repository interface cho feature Posts
abstract class PostRepository {
  /// Lấy tất cả các bài post
  ///
  /// Trả về:
  /// - [Right<List<Post>>] nếu thành công
  /// - [Left<Failure>] nếu có lỗi
  Future<Either<Failures, List<Post>>> getPosts();
  
  /// Lấy chi tiết một bài post theo id
  ///
  /// Tham số:
  /// - [id]: ID của bài post cần lấy
  ///
  /// Trả về:
  /// - [Right<Post>] nếu thành công
  /// - [Left<Failure>] nếu có lỗi
  Future<Either<Failures, Post>> getPost(int id);
  
  /// Lấy tất cả các bài post của một user
  ///
  /// Tham số:
  /// - [userId]: ID của user
  ///
  /// Trả về:
  /// - [Right<List<Post>>] nếu thành công
  /// - [Left<Failure>] nếu có lỗi
  Future<Either<Failures, List<Post>>> getPostsByUser(int userId);
  
  /// Tạo một bài post mới
  ///
  /// Tham số:
  /// - [post]: Dữ liệu của bài post mới
  ///
  /// Trả về:
  /// - [Right<Post>] nếu thành công
  /// - [Left<Failure>] nếu có lỗi
  Future<Either<Failures, Post>> createPost(Post post);
  
  /// Cập nhật một bài post
  ///
  /// Tham số:
  /// - [post]: Dữ liệu bài post đã cập nhật
  ///
  /// Trả về:
  /// - [Right<Post>] nếu thành công
  /// - [Left<Failure>] nếu có lỗi
  Future<Either<Failures, Post>> updatePost(Post post);
  
  /// Xóa một bài post
  ///
  /// Tham số:
  /// - [id]: ID của bài post cần xóa
  ///
  /// Trả về:
  /// - [Right<Unit>] nếu thành công
  /// - [Left<Failure>] nếu có lỗi
  Future<Either<Failures, Unit>> deletePost(int id);
}