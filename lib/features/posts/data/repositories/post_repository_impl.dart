import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/features/posts/data/data_sources/post_local_data_source.dart';
import 'package:flutter_clean_architecture/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/posts/data/models/post_model.dart';
import 'package:flutter_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture/features/posts/domain/repositories/post_repository.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostRepositoryImpl extends PostRepository {
  final PostRemoteDataSource postRemoteDataSource;
  final PostLocalDataSource postLocalDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl({
    required this.postRemoteDataSource,
    required this.postLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await postRemoteDataSource.getAllPosts();
        postLocalDataSource.cachedPost(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await postLocalDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPosts(Post post) async {
    final PostModel postModel =
        PostModel(title: post.title, body: post.body);

    return await _getMessage(() => postRemoteDataSource.addPost(postModel));
  }

  @override
  Future<Either<Failure, Unit>> updatePosts(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);
    
    return await _getMessage(() => postRemoteDataSource.updatePost(postModel));
  }

  @override
  Future<Either<Failure, Unit>> deletePosts(int postId) async {
    return await _getMessage(() => postRemoteDataSource.deletePost(postId));
  }

  Future<Either<Failure, Unit>> _getMessage(DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
