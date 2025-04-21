import 'package:app_pd_cocimiento/core/shared/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';

class CustomDropdownWidget<T, K> extends StatelessWidget {
  final T? selectedItem;
  final List<T> items;
  /// Función que extrae la clave de comparación del objeto T.
  final K Function(T item) valueExtractor;
  /// Función para mostrar la etiqueta del objeto.
  final String Function(T item) itemLabel;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  /// Texto que se mostrará encima del Dropdown (como un label)
  final String? label;
  /// Decoración opcional para el Dropdown.
  final InputDecoration? decoration;

  const CustomDropdownWidget({
    super.key,
    this.selectedItem,
    required this.items,
    required this.valueExtractor,
    required this.itemLabel,
    this.onChanged,
    this.hintText,
    this.label,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    // Extrae la clave del valor seleccionado, si existe.
    final K? selectedValue =
        selectedItem != null ? valueExtractor(selectedItem as T) : null;

    // Si se ha pasado una decoración, se usa; de lo contrario, se crea una decoración vacía
    final effectiveDecoration = decoration ?? const InputDecoration();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              fontSize: AppConstants.titleSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.blue,
            ),
          ),
        DropdownButtonFormField<K>(
          value: selectedValue,
          hint: hintText != null ? Text(hintText!) : null,
          isExpanded: true,
          decoration: effectiveDecoration.copyWith(labelText: null),
          items: items.map((T item) {
            return DropdownMenuItem<K>(
              alignment: Alignment.center,
              value: valueExtractor(item),
              child: Text(itemLabel(item), style: TextStyle(color: AppTheme.orange, fontWeight: FontWeight.bold),),
            );
          }).toList(),
          onChanged: (K? newValue) {
            T? matching;
            for (var item in items) {
              if (valueExtractor(item) == newValue) {
                matching = item;
                break;
              }
            }
            if (onChanged != null) {
              onChanged!(matching);
            }
          },
        ),
      ],
    );
  }
}
