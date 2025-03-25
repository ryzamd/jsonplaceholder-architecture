import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jsonplaceholder_app/core/errors/failures.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/repositories/post_repository.dart';

class GetPostDetail {
  final PostRepository repository;

  GetPostDetail({required this.repository});

  Future<Either<Failures, Post>> call(Params params) async {
    return repository.getPost(params.postId);
  }
}

class Params extends Equatable {
  final int postId;
  
  const Params({required this.postId});
  
  @override
  List<Object?> get props => [postId];
}