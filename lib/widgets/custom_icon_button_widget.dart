import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;     // Tamaño del botón (ancho/alto del círculo)
  final double iconSize; // Tamaño del icono dentro del botón
  final Color? splashColor;
  final Color? highlightColor;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = AppTheme.blue,
    this.iconColor = Colors.white,
    this.size = 48.0,
    this.iconSize = 24.0,
    this.splashColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        splashColor: splashColor ?? Colors.white.withValues(alpha: 0.3),
        highlightColor: highlightColor ?? Colors.white.withValues(alpha: 0.1),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
