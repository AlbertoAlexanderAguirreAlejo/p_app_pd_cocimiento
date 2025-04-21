import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';

class CustomChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;
  final Icon? leading;

  const CustomChipWidget({
    super.key,
    required this.label,
    this.onDeleted,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        avatar: leading, // se muestra si se provee
        label: Text(label),
        backgroundColor: Colors.white,
        deleteIconColor: AppTheme.red,
        onDeleted: onDeleted,
      ),
    );
  }
}