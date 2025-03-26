part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();
  
  @override
  List<Object> get props => [];
}

final class PostInitialState extends PostState {}

// State đang tải dữ liệu
final class PostLoadingState extends PostState {}

//State lấy danh sách post
final class PostsLoadedState extends PostState {
  final List<Post> posts;

  const PostsLoadedState(this.posts);

  @override
  List<Object> get props => [posts];
}

// State lấy detail của post
final class PostDetailLoadedState extends PostState {
  final Post post;

  const PostDetailLoadedState(this.post);

  @override
  List<Object> get props => [post];
}

//State create post
final class PostCreatedState extends PostState {
  final Post post;

  const PostCreatedState(this.post);

  @override
  List<Object> get props => [post];
}

//State update post
final class PostUpdatedState extends PostState {
  final Post post;

  const PostUpdatedState(this.post);

  @override
  List<Object> get props => [post];
}

//State delete post
final class PostDeletedState extends PostState {
  final int postId;

  const PostDeletedState(this.postId);

  @override
  List<Object> get props => [postId];
}

//State error
final class PostErrorState extends PostState {
  final String message;

  const PostErrorState(this.message);

  @override
  List<Object> get props => [message];
}