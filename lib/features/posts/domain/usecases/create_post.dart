import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jsonplaceholder_app/core/errors/failures.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/repositories/post_repository.dart';

class CreatePost {
  final PostRepository repository;

  CreatePost({required this.repository});

  Future<Either<Failures, Post>> call(Params params) async {
    return await repository.createPost(params.post);
  }
}

class Params extends Equatable {

  final Post post;

  const Params({required this.post});

  @override
  List<Post?> get props => [post];
}