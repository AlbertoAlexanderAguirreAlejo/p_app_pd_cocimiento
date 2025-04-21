import 'package:intl/intl.dart';

/// Formatea una fecha en formato ISO a un formato legible.
///
/// [isoDate] es la cadena de fecha en formato ISO, por ejemplo "2025-04-09T08:26:12".
///
/// [pattern] es el patrón de formateo que se desea utilizar (por defecto 'd MMM yyyy hh:mm:ss a').
///
/// [locale] es el locale a usar; por defecto se usa 'es_ES' para español (puedes ajustarlo según necesites).
String formatIsoDate(String isoDate, {String? pattern, String locale = 'es_ES'}) {
  // Intenta convertir la cadena ISO en un DateTime.
  final dateTime = DateTime.tryParse(isoDate);
  if (dateTime == null) return isoDate; // Si falla, retorna la cadena original.

  // Usa el patrón por defecto si no se especifica ninguno.
  final formatPattern = pattern ?? 'd MMM yyyy hh:mm:ss a';

  // Se crea un DateFormat con el patrón y locale.
  final formatter = DateFormat(formatPattern, locale);
  return formatter.format(dateTime);
}
