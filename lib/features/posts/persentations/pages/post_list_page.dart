import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/bloc/post_bloc.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/widgets/post_card.dart';

class PostListPage extends StatefulWidget {
  final int? userId;
  final String title;

  const PostListPage({super.key, this.userId, this.title = "Post List"});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  @override
  void initState() {
    super.initState();

    // Fetch dữ liệu khi khởi tạo widget
    _loadPosts();
  }

  void _loadPosts() {
    final bloc = context.read<PostBloc>();

    if (widget.userId != null) {
      bloc.add(GetPostByUserEvent(widget.userId!));
    } else {
      bloc.add(GetPostsEvent());
    }
  }

  /// Điều hướng đến trang chi tiết bài post
  void _navigateToDetail(Post post) {
    Navigator.pushNamed(
      context,
      '/post-detail',
      arguments: post.id,
    ).then((_) => _loadPosts()); // Reload khi quay lại
  }

  //show Dialog xác nhận xóa
  void _showDeleteConfirmation(Post post) {

    final outerContext = context;

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc muốn xóa bài viết này không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  outerContext.read<PostBloc>().add(DeletePostEvent(post.id));
                  Navigator.pop(dialogContext);
                },
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          // Xử lý các sự kiện sau khi state thay đổi
          if (state is PostDeletedState) {
            // Hiển thị thông báo khi xóa thành công
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã xóa bài viết thành công'),
                backgroundColor: Colors.green,
              ),
            );
            
            // Reload danh sách
            _loadPosts();
          } else if (state is PostErrorState) {
            // Hiển thị thông báo lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PostLoadingState) {
            // Hiển thị loading indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PostsLoadedState) {
            final posts = state.posts;
            
            if (posts.isEmpty) {
              // Hiển thị message khi không có bài post nào
              return const Center(
                child: Text('Không có bài viết nào.'),
              );
            }
            
            // Hiển thị danh sách bài post
            return RefreshIndicator(
              onRefresh: () async => _loadPosts(),
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  
                  return PostCard(
                    post: post,
                    onTap: () => _navigateToDetail(post),
                    onDelete: () => _showDeleteConfirmation(post),
                  );
                },
              ),
            );
          } else if (state is PostErrorState) {
            // Hiển thị error message
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã xảy ra lỗi: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPosts,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          
          // Initial state hoặc các state khác
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // FAB để thêm bài post mới
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/post-form',
          ).then((_) => _loadPosts()); // Reload khi quay lại
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
