import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/utils/input_formatters/number_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/constants/app_constants.dart';
import 'package:app_pd_cocimiento/widgets/custom_item_card_widget.dart';

/// Widget que permite seleccionar el nivel de un tanque.
/// Por defecto se puede seleccionar usando un slider discreto (Vacío, 1/4, 1/2, 3/4, Lleno),
/// y se puede cambiar a modo de entrada manual para asignar un valor personalizado entre 0 y 1.
class CustomTankLevelCardSliderWidget extends StatefulWidget {
  /// Título que aparecerá en el header de la tarjeta.
  final String title;

  /// Color de fondo para la cabecera.
  final Color headerColor;

  /// Valor inicial del nivel (discreto, 0..4).
  /// Se convertirá a una medida entre 0 y 1:
  /// 0 ⇒ 0.0, 1 ⇒ 0.25, 2 ⇒ 0.5, 3 ⇒ 0.75, 4 ⇒ 1.0.
  final double initialLevel;

  /// Callback que regresa la medida seleccionada (entre 0 y 1).
  final ValueChanged<double> onLevelChanged;

  /// Número de pasos discretos en el slider.
  final int pasos;

  const CustomTankLevelCardSliderWidget({
    super.key,
    required this.title,
    this.headerColor = AppTheme.blue,
    required this.initialLevel,
    required this.onLevelChanged,
    this.pasos = 4,
  });

  @override
  State<CustomTankLevelCardSliderWidget> createState() =>
      _CustomTankLevelCardSliderWidgetState();
}

class _CustomTankLevelCardSliderWidgetState
    extends State<CustomTankLevelCardSliderWidget> {
  // Flag para determinar el modo de ingreso: false ⇒ modo slider; true ⇒ entrada manual.
  bool _isManualMode = false;

  // Valor actual del nivel, representado como double (0 a 1).
  late double _currentValue;

  // Controlador para el TextField de entrada manual.
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Convertir el valor discreto (0..4) a un número entre 0 y 1.
    _currentValue = widget.initialLevel;
    // _currentValue = (widget.initialLevel.clamp(0, 4)) / 4.0;
    _textController =
        TextEditingController(text: _currentValue.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Convierte un índice discreto a un label.
  String _discreteLabel(int index) {
    switch (index) {
      case 0:
        return "Vacío";
      case 1:
        return "1/4";
      case 2:
        return "1/2";
      case 3:
        return "3/4";
      case 4:
        return "Lleno";
      default:
        return "";
    }
  }

  /// Dependiendo del valor actual, si coincide (dentro de un margen) con un valor discreto,
  /// retorna el label correspondiente; si no, muestra el valor en porcentaje.
  String _valueToLabel(double value) {
    // Usamos una tolerancia pequeña para detectar igualdad.
    const double tolerance = 1e-6;
    if ((value - 0.0).abs() < tolerance) return _discreteLabel(0);
    if ((value - 0.25).abs() < tolerance) return _discreteLabel(1);
    if ((value - 0.5).abs() < tolerance) return _discreteLabel(2);
    if ((value - 0.75).abs() < tolerance) return _discreteLabel(3);
    if ((value - 1.0).abs() < tolerance) return _discreteLabel(4);

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

  /// Actualiza el valor cuando se utiliza el slider.
  void _onSliderChanged(double newValue) {
    setState(() {
      _currentValue = newValue;
      _textController.text = _currentValue.toStringAsFixed(2);
    });
    widget.onLevelChanged(newValue);
  }

  /// Actualiza el valor a partir de la entrada manual.
  void _onManualChanged(String text) {
    final double? value = double.tryParse(text);
    if (value != null && value >= 0 && value <= 1) {
      setState(() {
        _currentValue = value;
      });
      widget.onLevelChanged(value);
    }
  }

  /// Cambia entre el modo slider y el modo manual.
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
    return CustomItemCardWidget(
      headerTitle: widget.title,
      headerColor: widget.headerColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila que muestra la etiqueta "Nivel:", el valor actual y un botón para cambiar el modo.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nivel:",
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
                tooltip: _isManualMode ? "Usar Slider" : "Entrada Manual",
                onPressed: _toggleMode,
              ),
            ],
          ),
          // Se muestra el slider o el TextField según el modo seleccionado.
          _isManualMode
              ? TextField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Valor (0 a 1)",
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    NumberInputFormatter(
                        minValue: 0, maxValue: 1, maxDecimals: 6)
                  ],
                  onSubmitted: _onManualChanged,
                  onChanged: _onManualChanged,
                )
              : Slider(
                  value: _currentValue,
                  min: 0,
                  max: 1,
                  divisions: widget.pasos,
                  label: _valueToLabel(_currentValue),
                  onChanged: _onSliderChanged,
                ),
        ],
      ),
    );
  }
}