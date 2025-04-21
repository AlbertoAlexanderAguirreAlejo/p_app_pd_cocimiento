import 'package:app_pd_cocimiento/core/shared/constants/app_constants.dart';
import 'package:flutter/services.dart';

/// Este formatter permite ingresar solo dígitos y un único punto decimal,
/// limita la cantidad de dígitos decimales a [maxDecimals] (por defecto [AppConstants.maxDecimales]),
/// y formatea números enteros para mostrarlos sin la parte decimal.
/// Además, corrige entradas como ".5" agregando un "0" inicial, elimina ceros a la izquierda
/// innecesarios y, opcionalmente, valida que el valor ingresado esté entre [minValue] y [maxValue].
///
/// En esta versión, si el usuario ya ha ingresado el punto decimal (por ejemplo "0.0" o "0.001"),
/// se respeta la entrada sin autoformatear. El autoformateo a entero solo se aplica cuando
/// el texto no contiene el punto decimal.
class NumberInputFormatter extends TextInputFormatter {
  /// Número máximo de dígitos permitidos después del punto decimal.
  final int maxDecimals;

  /// Valor mínimo permitido (opcional).
  final double? minValue;

  /// Valor máximo permitido (opcional).
  final double? maxValue;

  NumberInputFormatter({
    this.maxDecimals = AppConstants.maxDecimales,
    this.minValue,
    this.maxValue,
  });

  // Expresión regular que acepta solo dígitos y, opcionalmente, un único punto decimal.
  final RegExp _regExp = RegExp(r'^\d*\.?\d*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Permitir cadena vacía.
    if (text.isEmpty) {
      return newValue;
    }

    // Si el texto inicia con un punto, se antepone "0".
    if (text.startsWith('.')) {
      text = '0$text';
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    // Eliminar ceros iniciales innecesarios: si empieza con "0" y no es "0." y contiene más de un dígito.
    if (text.length > 1 && text.startsWith('0') && !text.startsWith('0.')) {
      if (text.contains('.')) {
        final parts = text.split('.');
        String integerPart = parts[0];
        integerPart = int.tryParse(integerPart)?.toString() ?? integerPart;
        text = '$integerPart.${parts[1]}';
      } else {
        text = int.tryParse(text)?.toString() ?? text;
      }
      int diff = text.length - newValue.text.length;
      return newValue.copyWith(
        text: text,
        selection: newValue.selection.copyWith(
          baseOffset: (newValue.selection.baseOffset + diff).clamp(0, text.length),
          extentOffset: (newValue.selection.extentOffset + diff).clamp(0, text.length),
        ),
      );
    }

    // Validar que el texto cumpla la expresión regular.
    if (!_regExp.hasMatch(text)) {
      return oldValue;
    }

    // Verificar que no haya más de un punto decimal.
    if ('.'.allMatches(text).length > 1) {
      return oldValue;
    }

    // Si hay punto decimal, limitar el número de dígitos decimales.
    if (text.contains('.')) {
      final parts = text.split('.');
      final decimalPart = parts.length > 1 ? parts[1] : '';
      if (decimalPart.length > maxDecimals) {
        return oldValue;
      }
    }

    // Intentar convertir el texto a double.
    double? value = double.tryParse(text);
    if (value != null) {
      // Si el texto termina en punto, se permite continuar la edición.
      if (text.endsWith('.')) {
        return newValue;
      }

      // Validar el rango (si se definieron) cuando el cursor esté al final,
      // asumiendo que es cuando el usuario ha concluido la edición.
      if (newValue.selection.baseOffset == text.length) {
        if (minValue != null && value < minValue!) {
          return oldValue;
        }
        if (maxValue != null && value > maxValue!) {
          return oldValue;
        }
      }

      // Si no se ingresó un punto, es decir, el usuario no está introduciendo decimales,
      // se puede formatear el número a entero.
      if (!text.contains('.')) {
        int intValue = value.toInt();
        if (value == intValue.toDouble() && newValue.selection.baseOffset == text.length) {
          final newText = intValue.toString();
          int diff = newText.length - text.length;
          return newValue.copyWith(
            text: newText,
            selection: TextSelection.collapsed(
              offset: (newValue.selection.baseOffset + diff).clamp(0, newText.length),
            ),
          );
        }
      }
    }

    return newValue.copyWith(text: text);
  }
}