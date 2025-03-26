import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonplaceholder_app/core/di/service_locator.dart' as di;
import 'package:jsonplaceholder_app/features/posts/domain/entities/post.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/bloc/post_bloc.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/pages/post_detail_page.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/pages/post_form_page.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/pages/post_list_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo dependency injection
  await di.initAllDependencies();
  
  runApp(const MyApp());
}

/// Widget gốc của ứng dụng
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSONPlaceholder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        // Định nghĩa các routes
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.sl<PostBloc>(),
                child: const PostListPage(),
              ),
            );
            
          case '/post-detail':
            final postId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.sl<PostBloc>(),
                child: PostDetailPage(postId: postId),
              ),
            );
            
          case '/post-form':
            final post = settings.arguments as Post?;
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.sl<PostBloc>(),
                child: PostFormPage(post: post),
              ),
            );
            
          case '/user-posts':
            final userId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.sl<PostBloc>(),
                child: PostListPage(
                  userId: userId,
                  title: 'Bài viết của User $userId',
                ),
              ),
            );
            
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(
                  child: Text('Không tìm thấy trang'),
                ),
              ),
            );
        }
      },
    );
  }
}