import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/constants/app_constants.dart';

class CustomItemCardWidget extends StatelessWidget {
  /// Título que se mostrará en la cabecera.
  final String headerTitle;

  /// Color de fondo de la cabecera.
  final Color headerColor;

  /// Widget que representa el contenido (body) de la tarjeta.
  final Widget body;

  /// Margen externo de la tarjeta.
  final EdgeInsetsGeometry margin;

  /// Radio de los bordes de la tarjeta.
  final double borderRadius;

  const CustomItemCardWidget({
    super.key,
    required this.headerTitle,
    required this.headerColor,
    required this.body,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabecera predefinida, solo requiere el título y el color.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: headerColor,
            child: Center(
              child: Text(
                headerTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.titleSize,
                ),
              ),
            ),
          ),
          // Cuerpo: widget que se pasa por parámetro.
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: body,
          ),
        ],
      ),
    );
  }
}
