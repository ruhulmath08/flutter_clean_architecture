import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/data/data_sources/post_local_data_source.dart';
import 'package:flutter_clean_architecture/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/posts/data/repositories/post_repository_impl.dart';
import 'package:flutter_clean_architecture/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_clean_architecture/features/posts/domain/use_cases/add_post.dart';
import 'package:flutter_clean_architecture/features/posts/domain/use_cases/delete_post.dart';
import 'package:flutter_clean_architecture/features/posts/domain/use_cases/get_all_posts.dart';
import 'package:flutter_clean_architecture/features/posts/domain/use_cases/update_post.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //BLoC
  sl.registerFactory(() => PostsBloc(getAllPosts: sl()));
  sl.registerFactory(
    () => AddDeleteUpdatePostBloc(
      addPost: sl(),
      updatePost: sl(),
      deletePost: sl(),
    ),
  );
  sl.registerFactory(() => LoginBloc());
  sl.registerFactory(() => SignUpBloc());

  //UseCases
  sl.registerLazySingleton(() => GetAllPostsUseCase(sl()));
  sl.registerLazySingleton(() => AddPostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));

  //Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      postRemoteDataSource: sl(),
      postLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //DataSource
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<PostLocalDataSource>(
    () => PostLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
