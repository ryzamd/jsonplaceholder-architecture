

import 'package:flutter/foundation.dart';
import 'package:jsonplaceholder_app/core/constants/api_constants.dart';
import 'package:jsonplaceholder_app/core/errors/exceptions.dart';
import 'package:jsonplaceholder_app/core/network/dio_client.dart';
import 'package:jsonplaceholder_app/features/posts/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
  
  Future<PostModel> getPost(int postId);

  Future<List<PostModel>> getPostByUser(int userId);

  Future<PostModel> createPost(PostModel postModel);

  Future<PostModel> updatePost(PostModel postModel);

  Future<bool> deletePost(int postId);
}

class PostRemoteDataSourceImplement extends PostRemoteDataSource{

  final DioClient dioClient;

  PostRemoteDataSourceImplement({required this.dioClient});

  @override
  Future<PostModel> createPost(PostModel postModel) async {
    try {
            // Chuyển đổi post thành JSON trên background thread
      final postJson = await compute(_postModelToJson, postModel);

      final response = await dioClient.post(
        ApiConstants.posts,
        data: postJson
      );

      return await compute(_postModeFromJson, response);

    } catch (e) {
       throw ServerException(
        message: 'Không thể tạo bài post mới',
      );
    }
  }

  @override
  Future<bool> deletePost(int postId) async {
    try {

      await dioClient.delete('${ApiConstants.posts}/$postId');
      
      return true;

    } catch (e) {
      throw ServerException(message: "Cannot delete this post");
    }
  }

  @override
  Future<PostModel> getPost(int postId) async {
    try {

      final response = await dioClient.get('${ApiConstants.posts}/$postId');

      // Parse JSON thành model trên background thread
      return await compute(_postModeFromJson, response);

    } catch (e) {
      throw ServerException(
        message: 'Không thể lấy chi tiết bài post với id: $postId',
      );
    }
  }

  @override
  Future<List<PostModel>> getPostByUser(int userId) async {
    try {

      final response = await dioClient.get(
        ApiConstants.posts,
        queryParameters: {'userId' : userId}
      );

       return await PostModel.fromJsonList(response as List);

    } catch (e) {
      throw ServerException(
        message: 'Không thể lấy danh sách bài post của user: $userId',
      );
    }
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await dioClient.get(ApiConstants.posts);
      return await PostModel.fromJsonList(response as List);

    } catch (e) {
      throw ServerException(
        message: 'Không thể lấy danh sách bài post',
      );
    }
  }

  @override
  Future<PostModel> updatePost(PostModel postModel) async {
    try {
      final postJson = await compute(_postModelToJson, postModel);

      final response = await dioClient.put(
        '${ApiConstants.posts}/${postModel.id}',
        data: postJson
      );

      return await compute(_postModeFromJson, response);
    } catch (e) {
      throw ServerException(
        message: 'Không thể cập nhật bài post với id: ${postModel.id}',
      );
    }
  }

  static PostModel _postModeFromJson(dynamic json){
    return PostModel.fromJson(json);
  }

  static Map<String, dynamic> _postModelToJson(PostModel post){
    return post.toJson();
  }
}