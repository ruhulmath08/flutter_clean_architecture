import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/widgets/loading_widget.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts/posts_state.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/pages/add_delete_update_posts.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/widgets/posts_page/message_display_widget.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/widgets/posts_page/post_list_widget.dart';

class PostsPages extends StatelessWidget {
  const PostsPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: const _BuildBody(),
      floatingActionButton: const _BuildFloatingActionButton(),
    );
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is LoadingPostsState) {
          return const LoadingWidget();
        } else if (state is LoadedPostsState) {
          return RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: PostListWidget(posts: state.posts),
          );
        } else if (state is ErrorPostsState) {
          return MessageDisplayWidget(message: state.message);
        }

        return const LoadingWidget();
      },
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<PostsBloc>(context).add(RefreshPostsEvent());
  }
}

class _BuildFloatingActionButton extends StatelessWidget {
  const _BuildFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddDeleteUpdatePosts(
              isUpdatePost: false,
            ),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
