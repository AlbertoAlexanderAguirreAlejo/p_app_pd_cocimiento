import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/widgets/custom_button_widget.dart';

class CustomFilterModalWidget extends StatelessWidget {
  /// Lista de widgets que serán los dropdowns de filtros.
  final List<Widget> dropdowns;
  /// Función que se ejecuta al presionar "Aplicar filtros".
  final VoidCallback onApply;
  /// Función que se ejecuta al presionar "Limpiar filtros".
  final VoidCallback onClear;

  const CustomFilterModalWidget({
    super.key,
    required this.dropdowns,
    required this.onApply,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            ...dropdowns,
            CustomButtonWidget(
              text: 'Aplicar filtros',
              extendWidth: true,
              onTap: () {
                onApply();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                onClear();
                Navigator.of(context).pop();
              },
              child: const Text('Limpiar filtros'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}