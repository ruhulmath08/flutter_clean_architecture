import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_event.dart';

class FormWidget extends StatefulWidget {
  final Post? post;
  final bool isUpdatePost;

  const FormWidget({
    Key? key,
    this.post,
    required this.isUpdatePost,
  }) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdatePost) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }
  }

  void _validateFormThenUpdateOrAddPost() {
    final post = Post(
      id: widget.isUpdatePost ? widget.post!.id : null,
      title: _titleController.text,
      body: _bodyController.text,
    );

    final isValidate = _formKey.currentState!.validate();
    if (isValidate) {
      if (widget.isUpdatePost) {
        BlocProvider.of<AddDeleteUpdatePostBloc>(context).add(
          UpdatePostEvent(post: post),
        );
      } else {
        BlocProvider.of<AddDeleteUpdatePostBloc>(context).add(
          AddPostEvent(post: post),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _titleController,
              validator: (val) => val!.isEmpty ? 'Title cannot be empty' : null,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _bodyController,
              validator: (val) => val!.isEmpty ? 'Body cannot be empty' : null,
              minLines: 6,
              maxLines: 10,
              decoration: const InputDecoration(hintText: 'Body'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _validateFormThenUpdateOrAddPost,
              icon: widget.isUpdatePost
                  ? const Icon(Icons.edit)
                  : const Icon(Icons.add),
              label: Text(widget.isUpdatePost ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
