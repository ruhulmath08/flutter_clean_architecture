import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: secondaryColor),
    );
  }
}
