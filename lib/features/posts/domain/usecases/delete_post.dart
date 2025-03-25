import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jsonplaceholder_app/core/errors/failures.dart';
import 'package:jsonplaceholder_app/features/posts/domain/repositories/post_repository.dart';

class DeletePost {
  final PostRepository repository;

  DeletePost({required this.repository});

  Future<Either<Failures, Unit>> call(Params params) async {
    return await repository.deletePost(params.postId);
  }
}

class Params extends Equatable{
  final int postId;

  const Params({required this.postId});
  
  @override
  List<Object?> get props => [postId];
}