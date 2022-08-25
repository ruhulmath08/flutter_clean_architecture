import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getAllPosts();

  Future<Either<Failure, Unit>> deletePosts(int postId);

  Future<Either<Failure, Unit>> updatePosts(Post post);

  Future<Either<Failure, Unit>> addPosts(Post post);
}
