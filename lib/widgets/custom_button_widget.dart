import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    this.color,
    this.textColor,
    this.borderColor,
    required this.text,
    required this.onTap,
    this.padding,
    this.borderRadius,
    this.extendWidth = false,
  });

  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final String text;
  final Function()? onTap;
  final double? padding;
  final double? borderRadius;
  final bool extendWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: extendWidth ? double.infinity : null,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: color ?? AppTheme.blue,
          border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
        ),
        child: Container(
          padding: EdgeInsets.all(padding ?? 15),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
