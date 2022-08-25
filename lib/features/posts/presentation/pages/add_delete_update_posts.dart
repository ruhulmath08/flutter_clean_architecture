import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/widgets/loading_widget.dart';
import 'package:flutter_clean_architecture/core/util/show_snack_bar_message.dart';
import 'package:flutter_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_state.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/pages/posts_pages.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/widgets/add_delete_update_posts/form_widget.dart';

class AddDeleteUpdatePosts extends StatelessWidget {
  final Post? post;
  final bool isUpdatePost;

  const AddDeleteUpdatePosts({
    Key? key,
    this.post,
    required this.isUpdatePost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdatePost ? 'Edit Post' : 'Add Post'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocConsumer<AddDeleteUpdatePostBloc, AddDeleteUpdatePostState>(
            listener: (context, state) {
              if (state is MessageAddDeleteUpdatePostState) {
                ShowSnackBarMessage().showErrorSnackBar(
                  message: state.message,
                  context: context,
                );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const PostsPages()),
                      (route) => false,
                );
              } else if (state is ErrorAddDeleteUpdatePostState) {
                ShowSnackBarMessage().showErrorSnackBar(
                  message: state.message,
                  context: context,
                );
              }
            },
            builder: (context, state) {
              if (state is LoadingAddDeleteUpdatePostState) {
                return const LoadingWidget();
              }
              return FormWidget(isUpdatePost: isUpdatePost, post: isUpdatePost ? post : null);
              // return FormWidget(
              //   isUpdatePost: isUpdatePost, post: isUpdatePost ? post : null,);
            },
          ),
        ),
      ),
    );
  }
}
