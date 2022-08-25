import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/strings/failures.dart';
import 'package:flutter_clean_architecture/core/strings/messages.dart';
import 'package:flutter_clean_architecture/features/posts/domain/use_cases/add_post.dart';
import 'package:flutter_clean_architecture/features/posts/domain/use_cases/delete_post.dart';
import 'package:flutter_clean_architecture/features/posts/domain/use_cases/update_post.dart';

import 'add_delete_update_post_event.dart';
import 'add_delete_update_post_state.dart';

class AddDeleteUpdatePostBloc
    extends Bloc<AddDeleteUpdatePostEvent, AddDeleteUpdatePostState> {
  final AddPostUseCase addPost;
  final DeletePostUseCase deletePost;
  final UpdatePostUseCase updatePost;

  AddDeleteUpdatePostBloc({
    required this.addPost,
    required this.deletePost,
    required this.updatePost,
  }) : super(AddDeleteUpdatePostStateInitial()) {
    on<AddDeleteUpdatePostEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDoneMessage = await addPost(event.post);
        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            addSuccessMessage,
          ),
        );
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDoneMessage = await updatePost(event.post);
        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            updateSuccessMessage,
          ),
        );
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDoneMessage = await deletePost(event.postId);
        emit(
          _eitherDoneMessageOrErrorState(
            failureOrDoneMessage,
            deleteSuccessMessage,
          ),
        );
      }
    });
  }

  AddDeleteUpdatePostState _eitherDoneMessageOrErrorState(
    Either<Failure, Unit> either,
    String message,
  ) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdatePostState(
        message: _mapFailureToMessage(failure),
      ),
      (posts) => MessageAddDeleteUpdatePostState(message: message),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;

      case EmptyCacheFailure:
        return emptyCacheFailureMessage;

      case OfflineFailure:
        return offlineFailureMessage;

      default:
        return 'Unexpected Error, please try again later.';
    }
  }
}
