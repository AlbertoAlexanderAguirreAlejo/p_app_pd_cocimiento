import 'package:app_pd_cocimiento/core/models/db/material.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/constants/app_constants.dart';
import 'package:app_pd_cocimiento/core/utils/input_formatters/number_input_formatter.dart';
import 'package:app_pd_cocimiento/widgets/custom_dropdown_widget.dart';

/// Widget que muestra la cabecera a la izquierda y el contenido a la derecha.
/// En la parte superior del contenido se coloca un dropdown que permite seleccionar un ítem,
/// y debajo se muestra el control para seleccionar el nivel (con slider o entrada manual).
class CustomTankLevelCardHorizontalWidget<T> extends StatefulWidget {
  /// Texto que se muestra en la cabecera izquierda (por ejemplo, un número o etiqueta).
  final String leftHeaderText;

  /// Lista de ítems para el Dropdown.
  final List<Materiales> dropdownItems;

  /// Ítem seleccionado actualmente en el Dropdown.
  final Materiales? selectedDropdownItem;

  /// Callback que se dispara al cambiar la selección del Dropdown.
  final ValueChanged<Materiales?> onDropdownChanged;

  /// Valor inicial del nivel (discreto de 0 a 4).
  /// Internamente se convierte a un valor entre 0 y 1:
  /// 0 → 0.0, 1 → 0.25, 2 → 0.5, 3 → 0.75, 4 → 1.0.
  final double initialLevel;

  /// Callback que se dispara cuando cambia el nivel (valor entre 0 y 1).
  final ValueChanged<double> onLevelChanged;

  /// Función para extraer la “clave” de cada ítem (si T es un objeto complejo).
  final dynamic Function(T item)? dropdownValueExtractor;

  /// Función para extraer la etiqueta del ítem.
  final String Function(T item)? dropdownLabelExtractor;

  /// Texto opcional para el hint o placeholder del Dropdown.
  final String? dropdownHint;

  const CustomTankLevelCardHorizontalWidget({
    super.key,
    required this.leftHeaderText,
    required this.dropdownItems,
    this.selectedDropdownItem,
    required this.onDropdownChanged,
    required this.initialLevel,
    required this.onLevelChanged,
    this.dropdownValueExtractor,
    this.dropdownLabelExtractor,
    this.dropdownHint,
  });

  @override
  State<CustomTankLevelCardHorizontalWidget<T>> createState() =>
      _CustomTankLevelCardHorizontalWidgetState<T>();
}

class _CustomTankLevelCardHorizontalWidgetState<T>
    extends State<CustomTankLevelCardHorizontalWidget<T>> {
  bool _isManualMode = false;
  late double _currentValue;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Convertir valor discreto (0..4) a double entre 0 y 1.
    _currentValue = (widget.initialLevel.clamp(0, 4)) / 4.0;
    _textController =
        TextEditingController(text: _currentValue.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Devuelve un string descriptivo para el valor actual (0 a 1).
  String _valueToLabel(double value) {
    const tolerance = 1e-6;
    if ((value - 0.0).abs() < tolerance) return 'Vacío';
    if ((value - 1.0).abs() < tolerance) return 'Lleno';
    // Convertir el valor a porcentaje.
    double percentage = value * 100;
    // Si el porcentaje es entero, lo mostramos sin decimales.
    if ((percentage - percentage.toInt()).abs() < tolerance) {
      return "${percentage.toInt()}%";
    } else {
      // De lo contrario, formateamos quitando los ceros finales.
      // Por ejemplo, 34.100000 se mostrará como "34.1"
      String s = percentage.toStringAsFixed(6);
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
      return "$s%";
    }
  }

  /// Se invoca al mover el slider.
  void _onSliderChanged(double newValue) {
    setState(() {
      _currentValue = newValue;
      _textController.text = _currentValue.toStringAsFixed(2);
    });
    widget.onLevelChanged(newValue);
  }

  /// Se invoca cuando se cambia el texto en el modo manual.
  void _onManualChanged(String text) {
    final double? value = double.tryParse(text);
    if (value != null && value >= 0 && value <= 1) {
      setState(() {
        _currentValue = value;
      });
      widget.onLevelChanged(value);
    }
  }

  /// Permite cambiar entre modo slider y manual.
  void _toggleMode() {
    setState(() {
      _isManualMode = !_isManualMode;
      if (_isManualMode) {
        _textController.text = _currentValue.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Bloque izquierdo: cabecera con fondo y texto centrado.
            Container(
              width: 50,
              color: widget.selectedDropdownItem != null ? AppTheme.darkGreen : AppTheme.red,
              alignment: Alignment.center,
              child: Text(
                widget.leftHeaderText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppConstants.titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Bloque derecho: contenido.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    // Dropdown en la parte superior.
                    CustomDropdownWidget<Materiales, int>(
                      selectedItem: widget.selectedDropdownItem,
                      items: widget.dropdownItems,
                      valueExtractor: (Materiales m) => m.idFabMaterial,
                      itemLabel: (Materiales m) => m.descCorta,
                      onChanged: widget.onDropdownChanged,
                      hintText: widget.dropdownHint,
                    ),
                    // Fila con el label del nivel y botón para alternar el modo.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nivel:',
                          style: TextStyle(
                            fontSize: AppConstants.subTitleSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _valueToLabel(_currentValue),
                          style: const TextStyle(
                            fontSize: AppConstants.subTitleSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isManualMode ? Icons.tune : Icons.edit,
                            color: AppTheme.blue,
                          ),
                          tooltip: _isManualMode ? 'Usar Slider' : 'Entrada Manual',
                          onPressed: _toggleMode,
                        ),
                      ],
                    ),
                    // Slider o TextField según modo.
                    _isManualMode
                        ? TextField(
                            controller: _textController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Valor (0 a 1)',
                              border: OutlineInputBorder(),
                            ),
                            inputFormatters: [
                              NumberInputFormatter(minValue: 0, maxValue: 1, maxDecimals: 6)
                            ],
                            onSubmitted: _onManualChanged,
                            onChanged: _onManualChanged,
                          )
                        : Slider(
                            value: _currentValue,
                            min: 0,
                            max: 1,
                            divisions: 20,
                            label: _valueToLabel(_currentValue),
                            onChanged: _onSliderChanged,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}