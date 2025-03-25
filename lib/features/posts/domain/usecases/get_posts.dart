
import 'package:dartz/dartz.dart';
import 'package:jsonplaceholder_app/core/errors/failures.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository;

  const GetPosts({required this.repository});
  
  Future<Either<Failures, List<Post>>> call() async {
    return repository.getPosts();
  }
}