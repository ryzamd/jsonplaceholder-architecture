import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/bloc/post_bloc.dart';


/// Page hiển thị chi tiết một bài post
class PostDetailPage extends StatefulWidget {
  /// ID của bài post cần hiển thị chi tiết
  final int postId;

  const PostDetailPage({
    super.key,
    required this.postId,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  void initState() {
    super.initState();
    
    // Fetch chi tiết bài post khi khởi tạo widget
    _loadPostDetail();
  }

  /// Load chi tiết bài post
  void _loadPostDetail() {
    context.read<PostBloc>().add(GetPostDetailEvent(widget.postId));
  }

  /// Điều hướng đến trang edit bài post
  void _navigateToEdit(Post post) {
    Navigator.pushNamed(
      context,
      '/post-form',
      arguments: post,
    ).then((_) => _loadPostDetail()); // Reload khi quay lại
  }

  /// Hiển thị dialog xác nhận xóa
  void _showDeleteConfirmation(Post post) {
    final outerContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bài viết'),
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostDeletedState) {
            // Hiển thị thông báo khi xóa thành công
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã xóa bài viết thành công'),
                backgroundColor: Colors.green,
              ),
            );
            
            // Quay lại màn hình trước đó
            Navigator.pop(context);
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
          } else if (state is PostDetailLoadedState) {
            final post = state.post;
            
            // Hiển thị chi tiết bài post
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Thông tin về user và ID
                  Row(
                    children: [
                      Text(
                        'ID: ${post.id}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'User ID: ${post.userId}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  
                  // Divider
                  const Divider(height: 32),
                  
                  // Nội dung bài post
                  Text(
                    post.body,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  
                  // Khoảng cách dưới cùng
                  const SizedBox(height: 80),
                ],
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
                    onPressed: _loadPostDetail,
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
      
      // Bottom bar chứa các action
      bottomNavigationBar: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostDetailLoadedState) {
            final post = state.post;
            
            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Nút xem các bài viết của cùng user
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/user-posts',
                            arguments: post.userId,
                          );
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('Bài viết cùng user'),
                      ),
                    ),
                    // Nút chỉnh sửa
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _navigateToEdit(post),
                        icon: const Icon(Icons.edit),
                        label: const Text('Chỉnh sửa'),
                      ),
                    ),
                    // Nút xóa
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _showDeleteConfirmation(post),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          'Xóa',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}