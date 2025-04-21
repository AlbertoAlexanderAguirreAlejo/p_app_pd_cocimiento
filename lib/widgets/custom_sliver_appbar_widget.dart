import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomSliverAppBarWidget extends StatelessWidget {
  const CustomSliverAppBarWidget({
    super.key,
    required String titleScreen,
  }) : _titleScreen = titleScreen;

  final String _titleScreen;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        _titleScreen,
        style: const TextStyle(color: AppTheme.dark, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      pinned: true,
      floating: true,
      centerTitle: true,
      automaticallyImplyLeading: false,
      forceElevated: true,
      shadowColor: Colors.black38,
      elevation: 3,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    );
  }
}
