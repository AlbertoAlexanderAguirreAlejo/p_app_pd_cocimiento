import 'package:intl/intl.dart';

/// Formatea la fecha (en formato ISO) y la concatena con el turno.
///
/// [isoDate] es la cadena de fecha en formato ISO, por ejemplo "2025-04-10T08:26:12".
///
/// [turno] es el entero que representa el turno.
///
/// [pattern] es el patrón de formateo; por defecto se utiliza 'd MMM yyyy'.
String formatHeader(String isoDate, int turno, {String? pattern, String locale = 'es_ES'}) {
  final dateTime = DateTime.tryParse(isoDate);
  if (dateTime == null) return "$isoDate ~ Turno $turno";

  final formatPattern = pattern ?? 'd MMM yyyy';
  final formatter = DateFormat(formatPattern, locale);
  return "${formatter.format(dateTime)} ~ Turno $turno";
}
