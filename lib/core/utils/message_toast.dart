import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/app.dart';

void messageToast({required String descripcion, Color? color}) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(descripcion),
      backgroundColor: color ?? AppTheme.darkGreen,
    ),
  );
}
