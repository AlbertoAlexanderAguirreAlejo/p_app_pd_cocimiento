import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/widgets/custom_button_widget.dart';

/// Widget que muestra dos pickers (horas y minutos) restringidos según un rango.
///
/// El widget recibe:
/// - [currentTime]: La hora actual para la selección inicial.
/// - [minTime] y [maxTime]: Definen el rango permitido. Si minTime es mayor que maxTime,
///   se asume que el rango cruza la medianoche (por ejemplo, de 22:00 a 06:00).
/// - [onConfirm]: Callback que se llama con el TimeOfDay seleccionado.
class CustomRestrictedTimePickerWidget extends StatefulWidget {
  final DateTime currentTime;
  final DateTime minTime;
  final DateTime maxTime;
  final ValueChanged<TimeOfDay> onConfirm;

  const CustomRestrictedTimePickerWidget({
    super.key,
    required this.currentTime,
    required this.minTime,
    required this.maxTime,
    required this.onConfirm,
  });

  @override
  State<CustomRestrictedTimePickerWidget> createState() =>
      _CustomRestrictedTimePickerWidgetState();
}

class _CustomRestrictedTimePickerWidgetState extends State<CustomRestrictedTimePickerWidget> {
  late int selectedHour;
  late int selectedMinute;

  /// Calcula la lista de horas permitidas según [minTime] y [maxTime].
  /// Si el rango no cruza la medianoche se genera de manera lineal;
  /// si cruza la medianoche se concatena la parte "de hoy" y "de mañana".
  List<int> get allowedHours {
    if (widget.minTime.hour <= widget.maxTime.hour) {
      // Rango dentro del mismo día.
      return List.generate(widget.maxTime.hour - widget.minTime.hour + 1,
          (index) => widget.minTime.hour + index);
    } else {
      // Rango que cruza la medianoche: de minTime.hour hasta 23 y de 0 hasta maxTime.hour.
      final hoursToday = List.generate(24 - widget.minTime.hour, (index) => widget.minTime.hour + index);
      final hoursTomorrow = List.generate(widget.maxTime.hour + 1, (index) => index);
      return hoursToday + hoursTomorrow;
    }
  }

  /// Calcula la lista de minutos permitidos para una hora dada [hour].
  /// Se restringen según si la hora es igual a la de minTime o maxTime (o en caso de cruce, en los extremos).
  List<int> allowedMinutesForHour(int hour) {
    int start = 0;
    int end = 59;

    if (widget.minTime.hour <= widget.maxTime.hour) {
      if (hour == widget.minTime.hour) {
        start = widget.minTime.minute;
      }
      if (hour == widget.maxTime.hour) {
        end = widget.maxTime.minute;
      }
    } else {
      // Caso de cruce de medianoche.
      if (hour >= widget.minTime.hour) {
        // Horas en la parte "de hoy"
        if (hour == widget.minTime.hour) {
          start = widget.minTime.minute;
        }
      } else {
        // Horas de la mañana (parte de "mañana")
        if (hour == widget.maxTime.hour) {
          end = widget.maxTime.minute;
        }
      }
    }
    // Devuelve la lista de minutos permitidos.
    final length = end - start + 1;
    return length > 0 ? List.generate(length, (index) => start + index) : <int>[];
  }

  @override
  void initState() {
    super.initState();
    selectedHour = widget.currentTime.hour;
    selectedMinute = widget.currentTime.minute;

    // Si el currentTime no está en el rango permitido, se fuerza a la primera opción.
    if (!allowedHours.contains(selectedHour)) {
      selectedHour = allowedHours.first;
    }
    final currentAllowedMinutes = allowedMinutesForHour(selectedHour);
    if (!currentAllowedMinutes.contains(selectedMinute)) {
      selectedMinute = currentAllowedMinutes.isNotEmpty ? currentAllowedMinutes.first : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cálculo de índices iniciales, asegurándose de que no sean negativos.
    final int initialHourIndex = allowedHours.indexOf(selectedHour);
    final List<int> currentAllowedMinutes = allowedMinutesForHour(selectedHour);
    int initialMinuteIndex = currentAllowedMinutes.indexOf(selectedMinute);
    if (initialMinuteIndex < 0) {
      initialMinuteIndex = 0;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pickers para horas y minutos.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Selector de horas
            SizedBox(
              width: 80,
              height: 150,
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(initialItem: initialHourIndex),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedHour = allowedHours[index];
                    // Cuando cambia la hora, actualizamos los minutos permitidos.
                    final mins = allowedMinutesForHour(selectedHour);
                    if (!mins.contains(selectedMinute)) {
                      selectedMinute = mins.isNotEmpty ? mins.first : 0;
                    }
                  });
                },
                children: allowedHours
                    .map((hour) => Center(
                          child: Text(hour.toString().padLeft(2, '0')),
                        ))
                    .toList(),
              ),
            ),
            // Selector de minutos
            SizedBox(
              width: 80,
              height: 150,
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(initialItem: initialMinuteIndex),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedMinute = currentAllowedMinutes[index];
                  });
                },
                children: currentAllowedMinutes
                    .map((minute) => Center(
                          child: Text(minute.toString().padLeft(2, '0')),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomButtonWidget(
          onTap: () {
            widget.onConfirm(TimeOfDay(hour: selectedHour, minute: selectedMinute));
          },
          extendWidth: true,
          text: "Confirmar",
        ),
      ],
    );
  }
}
