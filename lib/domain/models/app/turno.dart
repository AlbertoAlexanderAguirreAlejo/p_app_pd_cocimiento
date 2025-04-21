import 'package:flutter/material.dart';

class Turno {
  final int numero;
  final TimeOfDay start;
  final TimeOfDay end;

  const Turno({
    required this.numero,
    required this.start,
    required this.end,
  });
}