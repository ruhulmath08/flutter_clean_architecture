import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/app_theme.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts/posts_event.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/pages/posts_pages.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<PostsBloc>()..add(GetAllPostsEvent())),
        BlocProvider(create: (_) => di.sl<AddDeleteUpdatePostBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter clean architecture',
        theme: appTheme,
        home: const PostsPages(),
      ),
    );
  }
}

//https://www.youtube.com/watch?v=TjLpKnpKchw&list=PLwJ4sQ79Ehm69Bmed-XrRCc-_H1R3nWhd&index=14 : 14.00
