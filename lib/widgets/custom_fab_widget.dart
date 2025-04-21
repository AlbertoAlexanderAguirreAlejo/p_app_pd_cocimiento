import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';

class CustomFloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double elevation;
  final String? tooltip;

  const CustomFloatingActionButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.elevation = 2,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    // Valores por defecto utilizando AppTheme.
    final Color bgColor = backgroundColor ?? AppTheme.blue;
    final Color icColor = iconColor ?? Colors.white;

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: bgColor,
      elevation: elevation,
      child: Icon(
        icon,
        color: icColor,
      ),
    );
  }
}
