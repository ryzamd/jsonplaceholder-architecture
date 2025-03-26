import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:jsonplaceholder_app/core/errors/failures.dart';
import 'package:jsonplaceholder_app/core/network/network_info.dart';
import 'package:jsonplaceholder_app/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:jsonplaceholder_app/features/posts/data/models/post_model.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository{
  final NetworkInfo networkInfo;
  final PostRemoteDataSource postRemoteDataSource;

  PostRepositoryImpl({required this.networkInfo, required this.postRemoteDataSource});

  @override
  Future<Either<Failures, Post>> createPost(Post post) async {

    final postModel = await compute(
      (post) => PostModel(
        id: post.id,
        userId: post.userId,
        title: post.title,
        body: post.body
      ),
      post
    );

    return await _getPost(() => postRemoteDataSource.createPost(postModel));
  }

  @override
  Future<Either<Failures, Unit>> deletePost(int id) async {

    if(await networkInfo.isConnected){
      try {

        await postRemoteDataSource.deletePost(id);

        return const Right(unit);

      } on ServerFailure catch (e){

        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));

      } catch (e) {

        return Left(ServerFailure(message: "Cannot delete this post"));
      }

    } else {
      
      return const Left(NetWorkFailure());
    }
  }

  @override
  Future<Either<Failures, Post>> getPost(int id) async {

    return await _getPost(() => postRemoteDataSource.getPost(id));
  }

  @override
  Future<Either<Failures, List<Post>>> getPosts() async {

    return await _getPosts(() => postRemoteDataSource.getPosts());
  }

  @override
  Future<Either<Failures, List<Post>>> getPostsByUser(int userId) async {

    return await _getPosts(() => postRemoteDataSource.getPostByUser(userId));
  }

  @override
  Future<Either<Failures, Post>> updatePost(Post post) async {
    
    final postModel = await compute(
      (post) => PostModel(
        id: post.id,
        userId: post.userId,
        title: post.title,
        body: post.body
      ),
      post
    );

    return _getPost(() => postRemoteDataSource.updatePost(postModel));
  }

  Future<Either<Failures, List<Post>>> _getPosts(Future<List<PostModel>> Function() getPostsFunc) async {

    if(await networkInfo.isConnected){
      try {
        
        final post = await getPostsFunc();

        return Right(post);

      } on ServerFailure catch (e){

        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));

      } catch (e) {
        
        return const Left(ServerFailure(message: 'Lỗi không xác định khi lấy danh sách bài post'));
      }

    } else {
      
      return const Left(NetWorkFailure());
    }
  }

  Future<Either<Failures, Post>> _getPost(Future<PostModel> Function() getPostFunc ) async {

    if(await networkInfo.isConnected){
      try {
        
        final post = await getPostFunc();

        return Right(post);

      } on ServerFailure catch (e){

        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));

      } catch (e) {

         return const Left(ServerFailure(message: 'Lỗi không xác định khi thao tác với bài post'));
      }

    } else {

      return const Left(NetWorkFailure());
    }
  }
}