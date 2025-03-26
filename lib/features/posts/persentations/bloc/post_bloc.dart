import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/usecases/create_post.dart'
    as create;
import 'package:jsonplaceholder_app/features/posts/domain/usecases/delete_post.dart'
    as delete;
import 'package:jsonplaceholder_app/features/posts/domain/usecases/get_post_by_user.dart'
    as by_user;
import 'package:jsonplaceholder_app/features/posts/domain/usecases/get_post_detail.dart'
    as detail;
import 'package:jsonplaceholder_app/features/posts/domain/usecases/get_posts.dart';
import 'package:jsonplaceholder_app/features/posts/domain/usecases/update_post.dart'
    as update;

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final detail.GetPostDetail getPostDetail;
  final by_user.GetPostByUser getPostByUser;
  final create.CreatePost createPost;
  final update.UpdatePost updatePost;
  final delete.DeletePost deletePost;

  PostBloc({
    required this.getPosts,
    required this.getPostDetail,
    required this.getPostByUser,
    required this.createPost,
    required this.updatePost,
    required this.deletePost,
  }) : super(PostInitialState()) {
    on<GetPostsEvent>(_getPostEvent);
    on<GetPostByUserEvent>(_getPostByUserEvent);
    on<CreatePostEvent>(_createPostEvent);
    on<GetPostDetailEvent>(_getPostDetailEvent);
    on<UpdatePostEvent>(_updatePostEvent);
    on<DeletePostEvent>(_deletePostEvent);
  }

  FutureOr<void> _getPostEvent(
    GetPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoadingState());

    // Gọi usecase (chạy trên background thread)
    final result = await getPosts();

    //Chuyển đổi kết quả -> state sử dụng trên main thread (UI)
    result.fold(
      (failure) => emit(PostErrorState(failure.message)),
      (posts) => emit(PostsLoadedState(posts)),
    );
  }

  FutureOr<void> _getPostByUserEvent(
    GetPostByUserEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoadingState());

    final result = await getPostByUser(by_user.Params(userId: event.userId));

    result.fold(
      (failure) => emit(PostErrorState(failure.message)),
      (posts) => emit(PostsLoadedState(posts)),
    );
  }

  FutureOr<void> _createPostEvent(
    CreatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    final result = await createPost(create.Params(post: event.post));

    result.fold(
      (failure) => emit(PostErrorState(failure.message)),
      (post) => emit(PostCreatedState(post)),
    );
  }

  FutureOr<void> _getPostDetailEvent(
    GetPostDetailEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoadingState());

    final result = await getPostDetail(detail.Params(postId: event.postId));

    result.fold(
      (failure) => emit(PostErrorState(failure.message)),
      (post) => emit(PostDetailLoadedState(post)),
    );
  }

  FutureOr<void> _updatePostEvent(
    UpdatePostEvent event,
    Emitter<PostState> emit,
  ) async {
    final result = await updatePost(update.Params(post: event.post));

    result.fold(
      (failure) => emit(PostErrorState(failure.message)),
      (post) => emit(PostUpdatedState(post)),
    );
  }

  FutureOr<void> _deletePostEvent(
    DeletePostEvent event,
    Emitter<PostState> emit,
  ) async {
    final result = await deletePost(delete.Params(postId: event.postId));

    result.fold(
      (failure) => emit(PostErrorState(failure.message)),
      (_) => emit(PostDeletedState(event.postId)),
    );
  }
}
