import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jsonplaceholder_app/core/errors/failures.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/repositories/post_repository.dart';

class UpdatePost {
  final PostRepository repository;

  UpdatePost({required this.repository});

  Future<Either<Failures, Post>> call(Params params) async {
    return await repository.updatePost(params.post);
  }
}

class Params extends Equatable {

  final Post post;
  
  const Params({required this.post});

  @override
  List<Object?> get props => [post];
}