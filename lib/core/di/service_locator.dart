
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jsonplaceholder_app/core/network/dio_client.dart';
import 'package:jsonplaceholder_app/core/network/network_info.dart';
import 'package:jsonplaceholder_app/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:jsonplaceholder_app/features/posts/data/repositories/post_repository_impl.dart';
import 'package:jsonplaceholder_app/features/posts/domain/repositories/post_repository.dart';
import 'package:jsonplaceholder_app/features/posts/domain/usecases/create_post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/usecases/delete_post.dart';
import 'package:jsonplaceholder_app/features/posts/domain/usecases/get_post_by_user.dart';
import 'package:jsonplaceholder_app/features/posts/domain/usecases/get_post_detail.dart';
import 'package:jsonplaceholder_app/features/posts/domain/usecases/get_posts.dart';
import 'package:jsonplaceholder_app/features/posts/domain/usecases/update_post.dart';
import 'package:jsonplaceholder_app/features/posts/persentations/bloc/post_bloc.dart';
import 'package:logger/web.dart';


// Singleton instance cho DI
final GetIt sl = GetIt.instance;

// Khởi tạo tất cả DI trong main();
Future<void> initAllDependencies() async {

  //Core
  sl.registerLazySingleton(() => Logger());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl(), sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnectionChecker: sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Features - Post
  await _initPostsFeature();

    // Feature - Comments
  await _initCommentsFeature();
  
  // Feature - Albums
  await _initAlbumsFeature();
  
  // Feature - Photos
  await _initPhotosFeature();
  
  // Feature - Todos
  await _initTodosFeature();
  
  // Feature - Users
  await _initUsersFeature();
}

// Khởi tạo dependencies cho feature Posts
Future<void> _initPostsFeature() async {

  //Data Source
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImplement(dioClient: sl())
  );

  //Repositories
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      networkInfo: sl(),
      postRemoteDataSource: sl()
    )
  );

  //Usecases
  sl.registerLazySingleton(() => GetPosts(repository: sl()));
  sl.registerLazySingleton(() => GetPostByUser(repository: sl()));
  sl.registerLazySingleton(() => GetPostDetail(repository: sl()));
  sl.registerLazySingleton(() => CreatePost(repository: sl()));
  sl.registerLazySingleton(() => UpdatePost(repository: sl()));
  sl.registerLazySingleton(() => DeletePost(repository: sl()));

  //BloC
  sl.registerFactory(
    () => PostBloc(
      getPosts: sl(),
      getPostByUser: sl(),
      getPostDetail: sl(),
      createPost: sl(),
      updatePost: sl(),
      deletePost: sl(),
    )
  );
}

/// Khởi tạo dependencies cho feature Comments
Future<void> _initCommentsFeature() async {
  // Các dependencies sẽ được thêm sau khi triển khai feature
}

/// Khởi tạo dependencies cho feature Albums
Future<void> _initAlbumsFeature() async {
  // Các dependencies sẽ được thêm sau khi triển khai feature
}

/// Khởi tạo dependencies cho feature Photos
Future<void> _initPhotosFeature() async {
  // Các dependencies sẽ được thêm sau khi triển khai feature
}

/// Khởi tạo dependencies cho feature Todos
Future<void> _initTodosFeature() async {
  // Các dependencies sẽ được thêm sau khi triển khai feature
}

/// Khởi tạo dependencies cho feature Users
Future<void> _initUsersFeature() async {
  // Các dependencies sẽ được thêm sau khi triển khai feature
}