import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jsonplaceholder_app/core/errors/failures.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/repositories/post_repository.dart';

class GetPostByUser {
  final PostRepository repository;

  GetPostByUser({required this.repository});

  // Xem các posts đã được create by user
  Future<Either<Failures, List<Post>>> call(Params params) async {
    return await repository.getPostsByUser(params.userId);
  }
}

class Params extends Equatable {
  final int userId;

  const Params({required this.userId});

  @override
  List<Object?> get props => [userId];
}