part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

// Event để fetch tất cả bài post
final class GetPostsEvent extends PostEvent{}

// Event để fetch chi tiết 1 bài post
final class GetPostDetailEvent extends PostEvent{

  final int postId;

  const GetPostDetailEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

//Event để fetch các bài post của một user
final class GetPostByUserEvent extends PostEvent{
  final int userId;

  const GetPostByUserEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

//Event để tạo ra 1 post mới
final class CreatePostEvent extends PostEvent{
  final Post post;

  const CreatePostEvent(this.post);

    @override
  List<Object> get props => [post];
}

//Update post
final class UpdatePostEvent extends PostEvent{
  final Post post;

  const UpdatePostEvent(this.post);

    @override
  List<Object> get props => [post];
}

// Delete post
final class DeletePostEvent extends PostEvent{
  final int postId;

  const DeletePostEvent(this.postId);

  @override
  List<Object> get props => [postId];
}
