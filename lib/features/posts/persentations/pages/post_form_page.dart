import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/bloc/post_bloc.dart';


/// Page để tạo mới hoặc chỉnh sửa bài post
class PostFormPage extends StatefulWidget {
  /// Bài post cần chỉnh sửa (null nếu tạo mới)
  final Post? post;

  const PostFormPage({
    super.key,
    this.post,
  });

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  /// Key cho form validation
  final _formKey = GlobalKey<FormState>();
  
  /// Controller cho trường user ID
  final _userIdController = TextEditingController();
  
  /// Controller cho trường tiêu đề
  final _titleController = TextEditingController();
  
  /// Controller cho trường nội dung
  final _bodyController = TextEditingController();
  
  /// Kiểm tra form đang ở mode chỉnh sửa hay tạo mới
  bool get _isEditMode => widget.post != null;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo giá trị cho các controller nếu ở mode chỉnh sửa
    if (_isEditMode) {
      _userIdController.text = widget.post!.userId.toString();
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }
  }

  @override
  void dispose() {
    // Giải phóng controller khi widget bị dispose
    _userIdController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  /// Submit form
  void _submitForm() {
    // Kiểm tra form validation
    if (_formKey.currentState?.validate() ?? false) {
      final userId = int.parse(_userIdController.text);
      final title = _titleController.text;
      final body = _bodyController.text;
      
      // Tạo đối tượng Post với dữ liệu form
      final post = Post(
        id: _isEditMode ? widget.post!.id : 0,
        userId: userId,
        title: title,
        body: body,
      );
      
      // Dispatch event tương ứng
      if (_isEditMode) {
        context.read<PostBloc>().add(UpdatePostEvent(post));
      } else {
        context.read<PostBloc>().add(CreatePostEvent(post));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Chỉnh sửa bài viết' : 'Tạo bài viết mới'),
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostCreatedState || state is PostUpdatedState) {
            // Hiển thị thông báo thành công
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditMode
                      ? 'Đã cập nhật bài viết thành công'
                      : 'Đã tạo bài viết mới thành công',
                ),
                backgroundColor: Colors.green,
              ),
            );
            
            // Quay lại màn hình trước
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
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text field cho user ID
                  TextFormField(
                    controller: _userIdController,
                    decoration: const InputDecoration(
                      labelText: 'User ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập User ID';
                      }
                      
                      final userId = int.tryParse(value);
                      if (userId == null || userId <= 0) {
                        return 'User ID phải là số nguyên dương';
                      }
                      
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Text field cho tiêu đề
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Tiêu đề',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tiêu đề';
                      }
                      
                      if (value.length < 5) {
                        return 'Tiêu đề phải có ít nhất 5 ký tự';
                      }
                      
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Text field cho nội dung
                  Expanded(
                    child: TextFormField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        labelText: 'Nội dung',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập nội dung';
                        }
                        
                        if (value.length < 10) {
                          return 'Nội dung phải có ít nhất 10 ký tự';
                        }
                        
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Button submit
                  ElevatedButton(
                    onPressed: state is PostLoadingState ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: state is PostLoadingState
                        ? const CircularProgressIndicator()
                        : Text(
                            _isEditMode ? 'Cập nhật' : 'Tạo mới',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}