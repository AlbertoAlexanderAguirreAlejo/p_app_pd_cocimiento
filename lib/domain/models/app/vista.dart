import 'package:flutter/material.dart';

class Vista {
  final Widget screen;
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color? color;

  const Vista({
    required this.screen,
    required this.title,
    required this.subtitle,
    this.icon,
    this.color,
  });
}