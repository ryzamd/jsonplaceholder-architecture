import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  factory PostModel.create({
    required int userId,
    required String title,
    required String body,
  }) {
    return PostModel(id: 0, userId: userId, title: title, body: body);
  }

  static Future<List<PostModel>> fromJsonList(List<dynamic> jsonList){
    return compute(_parseList, jsonList);
  }

  static List<PostModel> _parseList(List<dynamic> parseList){
    return parseList.map((json) => PostModel.fromJson(json)).toList();
  }
}
