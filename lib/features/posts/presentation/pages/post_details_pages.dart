import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/widgets/post_details/post_details_widget.dart';

class PostDetailsPage extends StatelessWidget {
  final Post post;

  const PostDetailsPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: PostDetailsWidget(post: post),
    );
  }
}
